# coding:utf8
from app import app

if __name__ == "__main__":
    app.run("127.0.0.1", 80, threaded=True, debug=True)
