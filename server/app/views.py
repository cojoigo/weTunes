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


@server.before_request
def verify_content_type():
    if request.method != "GET":
        if "application/json" not in request.headers["content-type"]:
            raise errors.IncorrectContentTypeError()
        try:
            request.json
        except:
            raise errors.NoJSONDataError()


def requires_auth(function):
    @wraps(function)
    def wrapped(*args, **kwargs):
        if request.authorization is None:
            raise errors.BadCredentialsError("No credentials provided.")
        if request.authorization.username is None:
            raise errors.BadCredentialsError("No user id provided.")
        if request.authorization.password is None:
            raise errors.BadCredentialsError("No password provided.")
        username = request.authorization.username
        password = request.authorization.password
        user = models.User.query.get(username)
        if user is None:
            raise errors.NotFoundInDatabaseError("User not found.")
        password_hash = user.password_hash
        if password_hash != hashlib.sha512(password).hexdigest():
            raise errors.BadCredentialsError("Incorrect user password.")
        kwargs["user"] = user
        return function(*args, **kwargs)
    return wrapped


def requires_party(function):
    @wraps(function)
    def wrapped(*args, **kwargs):
        party_id = kwargs.get("party_id")
        party = models.Party.query.get(party_id)
        if party is None:
            raise errors.NotFoundInDatabaseError(details="Party not found.")
        if party.password_hash is not None:
            try:
                password = request.json["party_password"]
            except KeyError:
                raise errors.MissingInformationError("party_password")
            password_hash = party.password_hash
            if password_hash != hashlib.sha512(password).hexdigest():
                raise errors.BadCredentialsError(details="Incorrect party password.")
        kwargs["party"] = party
        return function(*args, **kwargs)
    return wrapped


def requires_vals(required_vals):
    """
    Checks for missing required values. This muckery is need for decorators with
    variables to work correctly.
    """
    def wrap(function):
        @wraps(function)
        def wrapped(*args, **kwargs):
            "Iterates through required_vals and checks if there are any not in the request"
            missing_vals = [val for val in required_vals if val not in request.json]
            if len(missing_vals) != 0:
                raise errors.MissingInformationError(missing_vals)
            return function(*args, **kwargs)
        return wrapped
    return wrap


@server.route("/create_user", methods=["POST"])
def create_user(*args, **kwargs):
    "Creates a user on the databse and returns the user info with a password"
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
@requires_vals(["party_name"])
def create_party(*args, **kwargs):
    user = kwargs.get("user")
    party_password = request.json.get("party_password", None)
    try:
        password_hash = hashlib.sha512(party_password).hexdigest()
    except TypeError:
        password_hash = None
    party = models.Party(name=request.json.get("party_name"),
                         password_hash=password_hash,
                         song_data=request.json.get("song_data", None),
                         creation_time=time(),
                         update_time=time(),
                         users=[],
                         host_id=user.id)
    db.session.add(party)
    db.session.commit()
    add_user_to_party(user, party)
    return jsonify(party.to_json())


@server.route("/", methods=["POST"])
@requires_vals(["arg"])
def index():
    return "a"


@server.route("/join_party/<int:party_id>", methods=["POST"])
@requires_auth
@requires_party
def join_party(*args, **kwargs):
    add_user_to_party(kwargs["user"], kwargs["party"])
    return jsonify(kwargs["party"].to_json())


def add_user_to_party(user, party):
    "Adds user to party"
    if user in party.users:  # Should this throw an error or just pass?
        return
    party.users.append(user)
    user.party = party
    db.session.commit()


@server.errorhandler(errors.GenericError)
def _handle_generic_errors(error):
    return error.to_json()


@server.errorhandler(sqlalchemy.exc.OperationalError)
def _handle_operational_error(error):
    db.session.rollback()
    return errors.NotFoundInDatabaseError(error).to_json()


@server.errorhandler(sqlalchemy.exc.IntegrityError)
def _handle_integrity_error(error):
    db.session.rollback()
    return errors.DatabaseIntegrityError(error).to_json()
