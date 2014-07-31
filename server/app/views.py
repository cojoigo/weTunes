#!/bin/python2

import hashlib
import uuid
from time import time
import sqlalchemy
from flask import request, jsonify
from app import server, db
import models
import errors
import decorators


@server.before_request
def verify_content_type():
    "Ensures content-type is correct for POST request"
    if request.method != "GET":
        if "application/json" not in request.headers["content-type"]:
            raise errors.IncorrectContentTypeError()
        try:
            request.json
        except:
            raise errors.NoJSONDataError()


@server.route("/create_user", methods=["POST"])
def create_user(*args, **kwargs):
    "Creates a user on the databse and returns the user info with a password"
    user_password = str(uuid.uuid4())
    password_hash = hashlib.sha512(user_password).hexdigest()
    user = models.User(password_hash=password_hash)
    db.session.add(user)
    db.session.commit()
    user_json = user.to_json()
    user_json["password"] = user_password
    return jsonify(user_json)


@server.route("/create_party", methods=["POST"])
@decorators.requires_user
@decorators.requires_vals(["name"])
def create_party(*args, **kwargs):
    user = kwargs.get("user")
    party_password = request.json.get("password", None)
    try:
        password_hash = hashlib.sha512(party_password).hexdigest()
    except TypeError:
        password_hash = None
    party = models.Party(name=request.json.get("name"),
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


@server.route("/join_party/<int:party_id>", methods=["POST"])
@decorators.requires_user
@decorators.requires_party
def join_party(*args, **kwargs):
    add_user_to_party(kwargs["user"], kwargs["party"])
    return jsonify(kwargs["party"].to_json())


@server.route("/update_party/<int:party_id>", methods=["GET", "POST"])
@decorators.requires_user
@decorators.requires_party
def update_party(*args, **kwargs):
    if request.method == "GET":
        return _guest_update_party(*args, **kwargs)
    return _host_update_party(*args, **kwargs)


def _guest_update_party(*args, **kwargs):
    party = kwargs["party"]
    return jsonify(party.to_json())


@decorators.requires_host
def _host_update_party(*args, **kwargs):
    "Updates the specified party with the request json"
    party = kwargs["party"]
    party.update_from_dict(**request.json)
    db.session.commit()
    return jsonify(party.to_json())


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


def add_user_to_party(user, party):
    "Adds user to party"
    if user in party.users:  # Should this throw an error or just pass?
        return
    party.users.append(user)
    user.party = party
    db.session.commit()
