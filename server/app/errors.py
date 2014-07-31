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
        self.response["message"] = self.__class__.__name__ + ": "

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
        self.response["message"] += "Not application/json"


class NoJSONDataError(GenericError):
    """
    Error raised when the content-type of a request is not application/json
    """
    
    def __init__(self):
        super(NoJSONDataError, self).__init__()
        self.response["message"] += "No valid JSON data provided"


class MissingInformationError(GenericError):
    """
    Error raised when there is some required data not provided along with a request
    """

    def __init__(self, missing_data):
        super(MissingInformationError, self).__init__()
        self.response["message"] += "Missing required data"
        self.response["missing_data"] = missing_data


class NotFoundInDatabaseError(GenericError):
    """
    Error raised when some resource was not found in the database
    """

    def __init__(self, details):
        super(NotFoundInDatabaseError, self).__init__()
        self.status_code = 404
        self.response["message"] += "Resource not found in database"
        self.response["details"] = details


class BadCredentialsError(GenericError):
    """
    Error raised when incorrect/missing user credentials are provided.
    """

    def __init__(self, details):
        super(BadCredentialsError, self).__init__()
        self.status_code = 401
        self.response["message"] += "The credentials provided were incorrect."
        self.response["details"] = details 


class DatabaseIntegrityError(GenericError):
    """
    Error raised when some invalid value was tried to be placed into the database.
    """

    def __init__(self, error):
        super(DatabaseIntegrityError, self).__init__()
        self.status_code = 500
        self.response["message"] += "The database failed to insert the data."
        self.response["details"] = str(error)

class InvalidAttributeError(GenericError):
    """
    Error raised when a request tries to update an illegal value.
    """

    def __init__(self, value):
        super(InvalidAttributeError, self).__init__()
        self.response["message"] += "Illegal value entered."
        self.response["details"] = str(value)
