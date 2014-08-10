update_party
=====================

Overview
---------------------
This provides a method to update an existing party's information.

REST Info
---------------------
### URL
https://sgoodwin.pythonanywhere.com/update_party/party_id

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
name | No | The chosen name for the party
password | Depends | The chosen password.
new_password | No | The new party password.
song_data | No | JSON containing song metadata. See relevant spec page.

### Response
Name | Value
-----|------
id | The unique id for the party.
song_data | The song data provided
creation_time | The time of creation in unix time.
update_time | The time of last update in unix time.
name | The unique name of the party. 

