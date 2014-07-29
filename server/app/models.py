#!/bin/python2

from app import db


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
                "party_name": self.name}
    

class User(db.Model):
    """
    A User represents both hosts and guests at a Party.
    """

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(128), index=True, nullable=True)
    password_hash = db.Column(db.String(256), nullable=False)
    party_id = db.Column(db.Integer, db.ForeignKey("party.id"))

    def to_json(self):
        return {"id": self.id, "user_name": self.name}
