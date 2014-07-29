create_party
=====================

Overview
---------------------
This provides a method to join a party on the server. 

REST Info
---------------------
### URL
https://sgoodwin.pythonanywhere.com/join_party/

### Allowed Methods
POST

### Headers
Name | Value
-----|------
Content-type | application/json

### Authentication
HTTP Basic, with user_id and user_password.


### Response
Name | Value
-----|------
id | The unique id for the party.
song_data | The song data provided
creation_time | The time of creation in unix time.
update_time | The time of last update in unix time.
party_name | The unique name of the party. 

