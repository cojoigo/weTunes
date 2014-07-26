#!/bin/python2

from flask import Flask
from flask.ext.sqlalchemy import SQLAlchemy


server = Flask(__name__)
server.config.from_object("config")
db = SQLAlchemy(server)

from app import views
