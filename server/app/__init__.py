#!/bin/python2

from flask import Flask

server = Flask(__name__)
from app import views