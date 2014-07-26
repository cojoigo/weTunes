create_party
=====================

Overview
---------------------
This provides a method to create a party on the server. Sets the host and
currently playing song to corruspond to the information sent in the request.

REST Info
---------------------
### URL
https://sgoodwin.pythonanywhere.com/create_party/

### Allowed Methods
POST

### Headers
Name | Value
Content-type | application/json

### Authentication
HTTP Basic, with user_id and user_password.


### Body 
Name | Required? | Value
party_name | Yes | The chosen name for the party
party_password | Yes | The chosen password. None/nil/void if there is no password.
song_data | No | JSON containing song metadata. See relevant spec page.

### Response
Name | Value
id | The unique id for the party.
song_data | The song data provided
creation_time | The time of creation in unix time.
update_time | The time of last update in unix time.


