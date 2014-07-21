#!/bin/python2

from app import server

@server.route("/")
def index():
    return "Hello"
