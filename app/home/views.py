# coding:utf8
from . import home
from flask import render_template, redirect, url_for, flash, session, request
from app.home.forms import RegistForm, LoginForm, UserDetailForm, PwdForm, CommentForm
from app.models import User, Userlog, Preview, Tag, Movie, Comment, Moviecol
from functools import wraps
from werkzeug.security import generate_password_hash
from werkzeug.utils import secure_filename
from app import db, app
from app.admin.views import change_filename
import uuid
import os
import stat


# 登录装饰器
def user_login_req(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "user" not in session:
            return redirect(url_for("home.login", next=request.url))  # request.args.get("next")
        return f(*args, **kwargs)

    return decorated_function


# 首页
@home.route("/<int:page>", methods=["GET"])
def index(page=None):
    if page is None:
        page = 1
    tags = Tag.query.all()
    tag_id = request.args.get("tag_id", 0)
    page_data = Movie.query
    # 标签
    if int(tag_id) != 0:
        page_data = page_data.filter_by(tag_id=int(tag_id))
    # 星级
    star = request.args.get("star", 0)
    if int(star) != 0:
        page_data = page_data.filter_by(star=int(star))
    # 时间
    time = request.args.get("time", 0)
    if int(time) != 0:
        if int(time) == 1:
            page_data = page_data.order_by(Movie.addtime.desc())
        else:
            page_data = page_data.order_by(Movie.addtime.asc())
    # 播放量
    pm = request.args.get("pm", 0)
    if int(pm) != 0:
        if int(pm) == 1:
            page_data = page_data.order_by(Movie.playnum.desc())
        else:
            page_data = page_data.order_by(Movie.playnum.asc())
    # 评论量
    cm = request.args.get("cm", 0)
    if int(cm) != 0:
        if int(cm) == 1:
            page_data = page_data.order_by(Movie.commentnum.desc())
        else:
            page_data = page_data.order_by(Movie.commentnum.asc())
    page_data = page_data.paginate(page=int(page), per_page=10)
    p = dict(
        tag_id=tag_id,
        star=star,
        time=time,
        pm=pm,
        cm=cm
    )
    return render_template("home/index.html", tags=tags, p=p, page_data=page_data)


@home.route("/login/", methods=["GET", "POST"])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        data = form.data
        user = User.query.filter_by(name=data["name"]).first()
        if not user.check_pwd(data["pwd"]):
            flash("密码错误", "err")
            return redirect(url_for("home.login"))
        session["user"] = user.name
        session["user_id"] = user.id
        userlog = Userlog(
            user_id=user.id,
            ip=request.remote_addr
        )
        db.session.add(userlog)
        db.session.commit()
        return redirect(request.args.get("next") or url_for("home.user"))
    return render_template("home/login.html", form=form)


@home.route("/logout/")
@user_login_req
def logout():
    session.pop("user", None)
    session.pop("user_id", None)
    return redirect(url_for("home.login"))


@home.route("/regist/", methods=["GET", "POST"])
def regist():
    form = RegistForm()
    if form.validate_on_submit():
        data = form.data
        user = User(
            name=data["name"],
            email=data["email"],
            phone=data["phone"],
            pwd=generate_password_hash(data["pwd"]),
            uuid=uuid.uuid4().hex,
            face="20180108150558dd20b1539be94e0b854315bc9e9b63b6.png",
            info=data["name"]
        )
        db.session.add(user)
        db.session.commit()
        flash("注册成功", "ok")
        return redirect(url_for("home.regist"))
    return render_template("home/register.html", form=form)


# 会员修改资料
@home.route("/user/", methods=["GET", "POST"])
@user_login_req
def user():
    form = UserDetailForm()
    user = User.query.get(session["user_id"])
    form.face.validators = []
    if request.method == "GET":
        form.name.data = user.name
        form.email.data = user.email
        form.phone.data = user.phone
        form.info.data = user.info
        form.face.data = user.face
    if form.validate_on_submit():
        data = form.data
        if form.face.data:
            file_face = secure_filename(form.face.data.filename)
            if not os.path.exists(app.config["UP_DIR"]):
                os.makedirs(app.config["UP_DIR"])
                os.chmod(app.config["UP_DIR"], stat.S_IRWXO)
            user_face = change_filename(file_face)
            form.face.data.save(app.config["UP_DIR"] + user_face)
            user.face = user_face
        name_count = User.query.filter_by(name=data["name"]).count()
        if data["name"] != user.name and name_count == 1:
            flash("昵称已经存在", "err")
            return redirect(url_for("home.user"))
        user.name = data["name"]
        email_count = User.query.filter_by(email=data["email"]).count()
        if data["email"] != user.email and email_count == 1:
            flash("邮箱已经存在", "err")
            return redirect(url_for("home.user"))
        user.email = data["email"]
        phone_count = User.query.filter_by(phone=data["phone"]).count()
        if data["phone"] != user.phone and phone_count == 1:
            flash("电话已经存在", "err")
            return redirect(url_for("home.user"))
        user.phone = data["phone"]
        user.info = data["info"]
        db.session.add(user)
        db.session.commit()
        flash("修改成功", "ok")
        return redirect(url_for("home.user"))
    return render_template("home/user.html", form=form, user=user)


@home.route("/pwd/", methods=["GET", "POST"])
@user_login_req
def pwd():
    form = PwdForm()
    if form.validate_on_submit():
        data = form.data
        user = User.query.filter_by(
            name=session["user"]
        ).first()
        from werkzeug.security import generate_password_hash
        user.pwd = generate_password_hash(data["new_pwd"])
        db.session.add(user)
        db.session.commit()
        flash("修改密码成功,请重新登录", "ok")
        return redirect(url_for("home.logout"))
    return render_template("home/pwd.html", form=form)


@home.route("/comments/<int:page>/")
@user_login_req
def comments(page=None):
    if page is None:
        page = 1
    page_data = Comment.query.join(
        Movie
    ).join(
        User
    ).filter(
        Movie.id == Comment.movie_id,
        User.id == session["user_id"]
    ).order_by(
        Comment.addtime.desc()
    ).paginate(page=page, per_page=10)
    return render_template("home/comments.html", page_data=page_data)


# 会员登录
@home.route("/loginlog/<int:page>/", methods=["GET"])
@user_login_req
def loginlog(page=None):
    if page is None:
        page = 1
    page_data = Userlog.query.filter_by(
        user_id=int(session["user_id"])
    ).order_by(
        Userlog.addtime.desc(), Userlog.id
    ).paginate(page=page, per_page=10)
    return render_template("home/loginlog.html", page_data=page_data)


# 添加收藏电影
@home.route("/moviecol/add/", methods=["GET"])
@user_login_req
def moviecol_add():
    mid = request.args.get("mid", "")
    uid = request.args.get("uid", "")
    moviecol_count = Moviecol.query.filter_by(
        user_id=int(uid),
        movie_id=int(mid)
    ).count()
    if moviecol_count == 1:
        data = dict(ok=0)
    elif moviecol_count == 0:
        moviecol = Moviecol(
            user_id=int(uid),
            movie_id=int(mid),
            content="废话"
        )
        db.session.add(moviecol)
        db.session.commit()
        data = dict(ok=1)
    import json
    return json.dumps(data)


# 收藏电影
@home.route("/moviecol/<int:page>", methods=["GET", "POST"])
@user_login_req
def moviecol(page=None):
    if page is None:
        page = 1
    page_data = Moviecol.query.join(
        Movie
    ).filter(
        Movie.id == Moviecol.movie_id,
        Moviecol.user_id == int(session["user_id"])
    ).order_by(
        Moviecol.addtime.desc(), Moviecol.id
    ).paginate(page=page, per_page=10)
    return render_template("home/movieCol.html",page_data=page_data)


# 上映预告
@home.route("/animation/")
def animation():
    data = Preview.query.all()
    return render_template("home/animation.html", data=data)


@home.route("/search/<int:page>/")
def search(page=None):
    if page is None:
        page = 1
    key = request.args.get("key", "")
    page_data = Movie.query.filter(
        Movie.title.ilike('%' + key + '%')
    ).order_by(Movie.addtime.desc()).paginate(page=page, per_page=10)
    return render_template("home/search.html", key=key, page_data=page_data)


@home.route("/play/<int:id>/<int:page>/", methods=["GET", "POST"])
def play(id=None, page=None):
    if page is None:
        page = 1
    movie = Movie.query.join(
        Tag
    ).filter(
        Tag.id == Movie.tag_id,
        Movie.id == int(id)
    ).first_or_404()

    page_data = Comment.query.join(
        Movie
    ).join(
        User
    ).filter(
        Movie.id == movie.id,
        User.id == Comment.user_id
    ).order_by(
        Comment.addtime.desc()
    ).paginate(page=page, per_page=10)

    if request.method == "GET":
        movie.playnum += 1
    form = CommentForm()
    if "user" in session and form.validate_on_submit():
        data = form.data
        comment = Comment(
            content=data["content"],
            movie_id=movie.id,
            user_id=session["user_id"]
        )
        movie.commentnum += 1
        db.session.add(comment)
        db.session.commit()
        flash("评论成功", "ok")
        return redirect(url_for("home.play", id=movie.id, page=1))
    db.session.add(movie)
    db.session.commit()
    return render_template("home/play.html", movie=movie, form=form, page_data=page_data)
