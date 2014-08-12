#!/bin/python2

from time import time
import uuid
import hashlib
from sqlalchemy.ext.mutable import Mutable
from app import db
import errors


class MutableDict(Mutable, dict):
    """
    Implementation of dictionary that allows mutation
    Taken from SQlAlchemy's website.
    Why this isn't in SQlAlchemy already, I don't know.
    """

    @classmethod
    def coerce(cls, key, value):
        "Convert plain dictionaries to MutableDict."

        if not isinstance(value, MutableDict):
            if isinstance(value, dict):
                return MutableDict(value)

            # this call will raise ValueError
            return Mutable.coerce(key, value)
        else:
            return value

    def __setitem__(self, key, value):
        "Detect dictionary set events and emit change events."

        dict.__setitem__(self, key, value)
        self.changed()

    def __delitem__(self, key):
        "Detect dictionary del events and emit change events."

        dict.__delitem__(self, key)
        self.changed()

    def __getstate__(self):
        return dict(self)

    def __setstate__(self, state):
        self.update(state)


class Party(db.Model):
    """
    A Party is a representation of a party
    """

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(128), index=True, unique=True, nullable=False)
    password_hash = db.Column(db.String(256))
    users = db.relationship("User", lazy="dynamic", backref="party")
    song_data = db.Column(MutableDict.as_mutable(db.PickleType))
    creation_time = db.Column(db.Integer)
    update_time = db.Column(db.Integer)
    host_id = db.Column(db.Integer, nullable=False)

    def to_json(self):
        return {"id": self.id, "song_data": self.song_data,
                "creation_time": self.creation_time,
                "update_time": self.update_time,
                "name": self.name,
                "user_count": len(self.users.all())}

    def update_from_dict(self, **kwargs):
        """
        Updates the object from a dictionary,
        ensures improper attributes don't get set.
        """
        print kwargs
        self._check_banned_keys(kwargs)
        party_password = kwargs.pop("new_password", None)
        try:
            kwargs["password_hash"] = hashlib.sha512(
                party_password).hexdigest()
        except TypeError:
            pass
        song_data = kwargs.get("song_data", {})
        song_data.pop("vote_data", None)
        if "song_title" in song_data:
            song_data["uuid"] = str(uuid.uuid4())
            song_data["vote_data"] = {"-1": 0, "1": 0}
        for key in kwargs:
            try:
                attr = getattr(self, key)
                if type(attr) == dict and type(key) == dict:
                    attr.update(key)
                else:
                    setattr(self, key, kwargs[key])
            except AttributeError:
                raise errors.InvalidAttributeError(key)
        self.update_time = time()

    def _check_banned_keys(self, vals):
        banned_vals = ["id", "password_hash", "users",
                       "creation_time", "host_id", "update_time"]
        invalid_vals = [val for val in banned_vals if val in vals]
        if len(invalid_vals) != 0:
            raise errors.InvalidAttributeError(invalid_vals)


class User(db.Model):
    """
    A User represents both hosts and guests at a Party.
    """

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(128), index=True, nullable=True)
    password_hash = db.Column(db.String(256), nullable=False)
    party_id = db.Column(db.Integer, db.ForeignKey("party.id"))
    vote_data = db.Column(MutableDict.as_mutable(db.PickleType))
    update_time = db.Column(db.Integer)

    def to_json(self):
        return {"id": self.id, "name": self.name}
