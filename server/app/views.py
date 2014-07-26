#!/bin/python2

import hashlib
import uuid
from functools import wraps
from time import time
import sqlalchemy
from flask import request, jsonify
from app import server, db
import models
import errors


def requires_auth(function):
    @wraps(function)
    def authorize():
        if request.authorization is None:
            raise errors.BadCredentialsError(details="No credentials provided.")
        if request.authorization.username is None:
            raise errors.BadCredentialsError(details="No user id provided.")
        if request.authorization.password is None:
            raise errors.BadCredentialsError(details="No password provided.")
        username = request.authorization.username
        password = request.authorization.password
        user = models.User.query.get(username)
        if user is None:
            raise errors.BadCredentialsError(details="User not found.")
        password_hash = user.password_hash
        if password_hash != hashlib.sha512(password).hexdigest():
            raise errors.BadCredentialsError(details="Incorrect password.")
        return function(user)
    return authorize


@server.before_request
def verify_content_type():
    if request.method != "GET":
        if "application/json" not in request.headers["content-type"]:
            raise errors.IncorrectContentTypeError()
        try:
            request.json
        except:
            raise errors.NoJSONDataError()


@server.route("/", methods=["GET", "POST"])
@requires_auth
def index(user):
    return "a"


@server.route("/create_user", methods=["POST"])
def create_user():
    user_password = str(uuid.uuid4())
    password_hash = hashlib.sha512(user_password).hexdigest()
    user = models.User(password_hash=password_hash)
    db.session.add(user)
    db.session.commit()
    user_json = user.to_json()
    user_json["user_password"] = user_password
    return jsonify(user_json)


@server.route("/create_party", methods=["POST"])
@requires_auth
def create_party(user):
    required_vals = ["party_name", "party_password"]
    check_required_vals(required_vals, request.json)
    try:
        password_hash = hashlib.sha512(request.json.get(
            "party_password")).hexdigest()
    except TypeError:
        password_hash = None
    party = models.Party(name=request.json.get("party_name"),
                         password=password_hash,
                         song_data=request.json.get("song_data", None),
                         creation_time=time(),
                         update_time=time(),
                         users=[user],
                         host_id=user.id)
    db.session.add(party)
    db.session.commit()
    user.party = party
    db.session.commit()
    return jsonify(party.to_json())


def check_required_vals(required_vals, request):
    "Iterates through required_vals and checks if there are any not in the request"
    missing_vals = [val for val in required_vals if val not in request]
    if len(missing_vals) != 0:
        raise errors.MissingInformationError(missing_vals)


@server.errorhandler(errors.GenericError)
def _handle_generic_errors(error):
    return error.to_json()


@server.errorhandler(sqlalchemy.exc.OperationalError)
def _handle_operational_error(error):
    db.session.rollback()
    return errors.NotFoundInDatabaseError().to_json()


@server.errorhandler(sqlalchemy.exc.IntegrityError)
def _handle_integrity_error(error):
    db.session.rollback()
    return errors.DatabaseIntegrityError(error).to_json()
