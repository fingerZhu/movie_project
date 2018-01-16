# coding:utf8
from . import home
from flask import render_template, redirect, url_for, flash, session, request
from app.home.forms import RegistForm, LoginForm
from app.models import User, Userlog
from functools import wraps
from werkzeug.security import generate_password_hash
from app import db
import uuid


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
            uuid=uuid.uuid4().hex
        )
        db.session.add(user)
        db.session.commit()
        flash("注册成功", "ok")
        return redirect(url_for("home.regist"))
    return render_template("home/register.html", form=form)


@home.route("/user/")
@user_login_req
def user():
    return render_template("home/user.html")


@home.route("/pwd/")
@user_login_req
def pwd():
    return render_template("home/pwd.html")


@home.route("/comments/")
@user_login_req
def comments():
    return render_template("home/comments.html")


@home.route("/loginlog/")
@user_login_req
def loginlog():
    return render_template("home/loginlog.html")


@home.route("/moviecol/")
@user_login_req
def moviecol():
    return render_template("home/movieCol.html")


@home.route("/animation/")
@user_login_req
def animation():
    return render_template("home/animation.html")


@home.route("/search/")
@user_login_req
def search():
    return render_template("home/search.html")


@home.route("/play/")
@user_login_req
def play():
    return render_template("home/play.html")