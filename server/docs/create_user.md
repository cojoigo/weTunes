create_user
=====================

Overview
---------------------
This provides a method to create a user on the server. Returns the user id and
a UUID for a password.

REST Info
---------------------
### URL
https://sgoodwin.pythonanywhere.com/create_user/

### Allowed Methods
POST

### Headers
Name | Value
-----|------
Content-type | application/json

### Response
Name | Value
-----|------
id | The unique id for the user.
user_name | The username for the user. None if none provided.
user_password | The password for the user. A random UUID generated on the server.



