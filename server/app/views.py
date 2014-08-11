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
            print request.json
        except:
            raise errors.NoJSONDataError()


@server.route("/create_user", methods=["POST"])
def create_user(*args, **kwargs):
    """
    Creates a user on the databse and returns the user info with a password
    See docs/create_user.md for more details
    """
    user_password = str(uuid.uuid4())
    password_hash = hashlib.sha512(user_password).hexdigest()
    user = models.User(password_hash=password_hash, vote_data={"uuid": None,
                                                               "vote": None})
    db.session.add(user)
    db.session.commit()
    user_json = user.to_json()
    user_json["password"] = user_password
    return jsonify(user_json)


@server.route("/create_party", methods=["POST"])
@decorators.requires_user
@decorators.requires_vals(["name"])
def create_party(*args, **kwargs):
    """
    Creates a party on the server and returns the details
    See docs/create_party.md for more details.
    """

    user = kwargs.get("user")
    party_password = request.json.get("password", None)
    if party_password == "" or party_password is None:
        password_hash = None
    else:
        password_hash = hashlib.sha512(party_password).hexdigest()

    song_data = request.json.get("song_data", {})
    # This following line is mostly for testing.
    song_data["vote_data"] = {"-1": 0, "1": 0}
    song_data["uuid"] = str(uuid.uuid4())
    party = models.Party(name=request.json.get("name"),
                         password_hash=password_hash,
                         song_data=song_data,
                         creation_time=time(),
                         update_time=time(),
                         users=[],
                         host_id=user.id)
    # party = models.Party(name=request.json["name"],
    #                      users=[],
    #                      password_hash=password_hash,
    #                      host_id=user.id,
    #                      update_time=time(),
    #                      creation_time=time())
    # party.update_from_dict({"song_title": })
    db.session.add(party)
    db.session.commit()
    add_user_to_party(user, party)
    return jsonify(party.to_json())


@server.route("/join_party/<party_id>", methods=["POST"])
@decorators.requires_user
@decorators.requires_party
def join_party(*args, **kwargs):
    """
    Adds the user to the current party. See docs/join_party.md for more details
    """

    add_user_to_party(kwargs["user"], kwargs["party"])
    return jsonify(kwargs["party"].to_json())


@server.route("/update_party/<party_id>", methods=["POST"])
@decorators.requires_user
@decorators.requires_party
@decorators.requires_user_in_party
@decorators.requires_host
def update_party(*args, **kwargs):
    """
    Updates the party with the supplied information.
    """

    party = kwargs["party"]
    party.update_from_dict(**request.json)
    db.session.commit()
    return jsonify(party.to_json())


@server.route("/refresh_party/<party_id>", methods=["POST"])
@decorators.requires_user
@decorators.requires_party
@decorators.requires_user_in_party
def refresh_party(*args, **kwargs):
    """
    Sends the party information.
    """

    return jsonify(kwargs["party"].to_json())


@server.route("/get_parties", methods=["GET"])
@decorators.requires_user
def get_parties(*args, **kwargs):
    """
    Returns a list of all parties
    """

    party_list = models.Party.query.all() or []
    json_party_list = [p.to_json() for p in party_list]
    # Flask jsonify has bug with raw arrays, use
    # standard json lib instead
    import json
    return json.dumps(json_party_list)


@server.route("/vote/<party_id>", methods=["POST"])
@decorators.requires_user
@decorators.requires_party
@decorators.requires_user_in_party
@decorators.requires_vals(["song_title", "vote"])
def vote(*args, **kwargs):
    """
    Interface for voting on a party.
    """

    user = kwargs["user"]
    party = kwargs["party"]
    song_title = request.json["song_title"]
    vote = request.json["vote"]
    if vote != -1 and vote != 1:
        raise errors.InvalidAttributeError("vote")
    if song_title != party.song_data.get("song_title", None):
        raise errors.OutOfSyncError()
    if party.song_data["uuid"] == user.vote_data["uuid"]:
        if vote != user.vote_data["vote"]:
            party.song_data["vote_data"][str(user.vote_data["vote"])] -= 1
            user.vote_data["vote"] *= -1
            party.song_data["vote_data"][str(user.vote_data["vote"])] += 1
    else:
        user.vote_data["uuid"] = party.song_data["uuid"]
        user.vote_data["vote"] = vote
        party.song_data["vote_data"][str(user.vote_data["vote"])] += 1

    db.session.commit()
    return jsonify(party.to_json())


@server.route("/clean", methods=["GET"])
def clean(*args, **kwargs):
    """
    Removes old parties from the database.
    Called via a cronjob on the server.
    """

    cutoff_time = time() - (60 * 30)
    parties = models.Party.query.all()
    [db.session.delete(p) for p in parties
     if p.update_time < cutoff_time]
    db.session.commit()
    return "Done."


@server.errorhandler(errors.GenericError)
def _handle_generic_errors(error):
    "Error handler for user-defined errors."

    return error.to_json()


@server.errorhandler(sqlalchemy.exc.OperationalError)
def _handle_operational_error(error):
    "Error handler for OperationalErrors"

    db.session.rollback()
    return errors.NotFoundInDatabaseError(error).to_json()


@server.errorhandler(sqlalchemy.exc.IntegrityError)
def _handle_integrity_error(error):
    "Error handler for IntegrityErrors"

    db.session.rollback()
    return errors.DatabaseIntegrityError(error).to_json()


def add_user_to_party(user, party):
    "Adds user to party. If the user is already in a party, does nothing"

    if user in party.users:  # Should this throw an error or just pass?
        return
    party.users.append(user)
    user.party = party
    db.session.commit()
