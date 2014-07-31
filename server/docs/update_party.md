update_party
=====================

Overview
---------------------
This provides a method to update an existing party on a 

REST Info
---------------------
### URL
https://sgoodwin.pythonanywhere.com/update_party/<party_id>

### Allowed Methods
POST

### Headers
Name | Value
-----|------
Content-type | application/json

### Authentication
HTTP Basic, with user_id and user_password.
Requires the user to be the current host.


### Body 
Name | Required? | Value
-----|-----------|------
party_name | Yes | The chosen name for the party
party_password | Yes | The chosen password. None/nil/void if there is no password.
song_data | No | JSON containing song metadata. See relevant spec page.

### Response
Name | Value
-----|------
id | The unique id for the party.
song_data | The song data provided
creation_time | The time of creation in unix time.
update_time | The time of last update in unix time.
party_name | The unique name of the party. 

