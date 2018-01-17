# coding:utf8
from . import home
from flask import render_template, redirect, url_for, flash, session, request
from app.home.forms import RegistForm, LoginForm, UserDetailForm, PwdForm
from app.models import User, Userlog,Preview
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


@home.route("/")
def index():
    return render_template("home/index.html")


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


@home.route("/comments/")
@user_login_req
def comments():
    return render_template("home/comments.html")


# 会员登录
@home.route("/loginlog/<int:page>",methods=["GET"])
@user_login_req
def loginlog(page=None):
    if page is None:
        page =1
    page_data = Userlog.query.filter_by(
        user_id = int(session["user_id"])
    ).order_by(
        Userlog.addtime.desc(), Userlog.id
    ).paginate(page=page, per_page=10)
    return render_template("home/loginlog.html",page_data=page_data)


@home.route("/moviecol/")
@user_login_req
def moviecol():
    return render_template("home/movieCol.html")


# 上映预告
@home.route("/animation/")
def animation():
    data = Preview.query.all()
    return render_template("home/animation.html",data=data)


@home.route("/search/")
def search():
    return render_template("home/search.html")


@home.route("/play/")
def play():
    return render_template("home/play.html")
