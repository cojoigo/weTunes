#!/bin/python2
from flask import jsonify


class GenericError(Exception):
    """
    Base class for all exceptions thrown
    """

    def __init__(self):
        super(GenericError, self).__init__()
        self.status_code = 400
        self.response = {}
        self.response["error_name"] = self.__class__.__name__

    def to_json(self):
        "Returns the response dictionary as a json object"
        response = jsonify(self.response)
        response.status_code = self.status_code
        return response


class IncorrectContentTypeError(GenericError):
    """
    Error raised when the content-type of a request is not application/json
    """

    def __init__(self):
        super(IncorrectContentTypeError, self).__init__()
        self.response["message"] = "Not application/json"


class NoJSONDataError(GenericError):
    """
    Error raised when the content-type of a request is not application/json
    """

    def __init__(self):
        super(NoJSONDataError, self).__init__()
        self.response["message"] = "No valid JSON data provided"


class MissingInformationError(GenericError):
    """
    Error raised when there is some required data not provided
    along with a request
    """

    def __init__(self, missing_data):
        super(MissingInformationError, self).__init__()
        self.response["message"] = "Missing required data"
        self.response["missing_data"] = missing_data


class NotFoundInDatabaseError(GenericError):
    """
    Error raised when some resource was not found in the database
    """

    def __init__(self, message):
        super(NotFoundInDatabaseError, self).__init__()
        self.status_code = 404
        self.response["message"] = message


class BadCredentialsError(GenericError):
    """
    Error raised when incorrect/missing user credentials are provided.
    """

    def __init__(self, message):
        super(BadCredentialsError, self).__init__()
        self.status_code = 401
        self.response["message"] = message


class UserNotInPartyError(GenericError):
    """
    Error raised when a user tries to access a party
    they are not a guest/host of.
    """

    def __init__(self, user, party):
        self.response["message"] = "User is not in the specified party."
        self.response["user"] = user
        self.response["party"] = party


class DatabaseIntegrityError(GenericError):
    """
    Error raised when some invalid value was tried to be
    placed into the database.
    """

    def __init__(self, error):
        super(DatabaseIntegrityError, self).__init__()
        self.status_code = 500
        self.response["message"] = "The database failed to insert the data."
        self.response["details"] = str(error)


class InvalidAttributeError(GenericError):
    """
    Error raised when a request tries to update an illegal value.
    """

    def __init__(self, value):
        super(InvalidAttributeError, self).__init__()
        self.response["message"] = "Illegal value entered."
        self.response["details"] = str(value)


class OutOfSyncError(GenericError):
    """
    Error raised when a guest tries to vote on a song that isn't current
    Not an error that gets displayed to the guest, but should cause
    the client to refresh the party data.

    Shouldn't happen too much, but it is not abnormal for it to
    occur.
    """

    def __init__(self):
        super(InvalidAttributeError, self).__init__()
        self.response["message"] = "Your local party data is not up-to-date."
