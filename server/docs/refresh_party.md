refresh_party
=====================

Overview
---------------------
This provides a method to get the updated info for a party.

### URL
https://sgoodwin.pythonanywhere.com/refresh_party/party_id

### Allowed Methods
POST

### Authentication
HTTP Basic, with user_id and user_password.

### Body 
Name | Required? | Value
-----|-----------|------
password | Depends | The party's password. Needed if the party has a password. 

### Response
Name | Value
-----|------
id | The unique id for the party.
song_data | The song data, including the vote counts.
creation_time | The time of creation in unix time.
update_time | The time of last update in unix time.
name | The unique name of the party. 

