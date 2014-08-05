#!/bin/python2

from time import time
import hashlib
from app import db
import errors


class Party(db.Model):
    """
    A Party is a representation of a party 
    """

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(128), index=True, unique=True, nullable=False)
    password_hash = db.Column(db.String(256))
    users = db.relationship("User", lazy="dynamic", backref="party")
    song_data = db.Column(db.PickleType)
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
        self._check_banned_keys(kwargs)
        party_password = kwargs.pop("password", None)
        try:
            kwargs["password_hash"] = hashlib.sha512(party_password).hexdigest()
        except TypeError:
            pass
        for key in kwargs:
            try:
                getattr(self, key)
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

    def to_json(self):
        return {"id": self.id, "name": self.name}
