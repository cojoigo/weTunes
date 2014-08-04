#!/bin/python2

import hashlib
from functools import wraps
from flask import request
import models
import errors


def requires_user(function):
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
            raise errors.NotFoundInDatabaseError("Party not found.")
        if party.password_hash is not None:
            try:
                password = request.json["password"]
            except KeyError:
                raise errors.MissingInformationError("password")
            password_hash = party.password_hash
            if password_hash != hashlib.sha512(password).hexdigest():
                raise errors.BadCredentialsError("Incorrect party password.")
        kwargs["party"] = party
        return function(*args, **kwargs)
    return wrapped


def requires_host(function):
    @wraps(function)
    def wrapped(*args, **kwargs):
        user = kwargs["user"]
        party = kwargs["party"]
        if user.id != party.host_id:
            raise errors.BadCredentialsError("User not party host.")
        return function(*args, **kwargs)
    return wrapped


def requires_vals(required_vals):
    """
    Checks for missing required values.
    This muckery is need for decorators with variables to work correctly.
    """
    def wrap(function):
        """
        Iterates through required_vals and checks if there are any not in the
        request. Raises MissingInformationError if needed.
        """
        @wraps(function)
        def wrapped(*args, **kwargs):
            missing_vals = [val for val in required_vals
                            if val not in request.json]
            if len(missing_vals) != 0:
                raise errors.MissingInformationError(missing_vals)
            return function(*args, **kwargs)
        return wrapped
    return wrap
