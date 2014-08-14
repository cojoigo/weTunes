Server-Side Software
=====================

Overview
---------------------
All of the files required to operate the server are located under this directory.
To run the sever application, you must have the following installed:

- Python 2
- Flask
- SQLAlchemy

You also need to generate your own SSL credentials and place them in the credentials folder.
The files are expected to be named server.key and server.crt, but if you edit start.py you can change them to whatever you like.
You should also disable the debug mode of the server by remove "debug=True" from start.py after you are done with tweaking/editing.

To start the server, you then run start.py in your Python 2 interpreter. 



If you wish to develop a client for the sever, refer to the documentation in the docs folder.
It provides information on each request that you can make on the sever and includes details on the response.



Files
---------------------

### Main folder
Name | Details 
-----|------
app.db | The SQLite database file.
config.py | Misc. config parameters.
db_create.py | Creates a blank database.
db_migrate.py | Handles migration schemes.
db_update.py | Updates the DB to the latest schema.
start.py | Starts the server application.


### App
Name | Details 
-----|------
decorators.py | Contains all custom Python function decorators used.
errors.py | Contains all custom errors raised during operation.
models.py | Contains the models for the two database objects.
views.py | Contains the different view (URLs) you can request to preform operations at.
