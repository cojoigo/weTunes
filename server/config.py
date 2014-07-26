#!/bin/python2

import os


base_directory = os.path.abspath(os.path.dirname(__file__))

SQLALCHEMY_DATABASE_URI = "sqlite:///" + os.path.join(base_directory, "app.db")
SQLALCHEMY_MIGRATE_REPO = os.path.join(base_directory, "database_repo")
