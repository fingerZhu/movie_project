# coding:utf8
from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
import pymysql
import os

app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = "mysql+pymysql://root:finger@127.0.0.1:3306/movie"
# app.config["SQLALCHEMY_COMMIT_ON_TEARDOWN"] = True 请求结束自动提交
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = True
app.config["SECRET_KEY"] = "3e0bc98670194707a8dc72d3d3e8ca42"
app.config["UP_DIR"] = os.path.join(os.path.abspath(os.path.dirname(__file__)), "static/uploads/")
app.config["DEBUG"] = True
db = SQLAlchemy(app)

from app.home import home as home_blueprint
from app.admin import admin as admin_blueprint

app.register_blueprint(home_blueprint)
app.register_blueprint(admin_blueprint, url_prefix="/admin")


@app.errorhandler(404)
def page_not_found(e):
    return render_template("home/404.html"), 404


@app.errorhandler(500)
def internal_server_error(e):
    return render_template("home/500.html"), 500
