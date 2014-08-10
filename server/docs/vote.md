vote
=====================

Overview
---------------------
This provides a method to vote to skip on the current song.

### URL
https://sgoodwin.pythonanywhere.com/vote/party_id

### Allowed Methods
POST

### Headers
Name | Value
-----|------
Content-type | application/json

### Authentication
HTTP Basic, with user_id and user_password.

### Body 
Name | Required? | Value
-----|-----------|------
song_title | Yes | The name of the song you are voting on.
vote | Yes | Integer representing what you voted for. 1 for skip, -1 for not.


### Response
Name | Value
-----|------
id | The unique id for the party.
song_data | The song data, including the vote counts.
creation_time | The time of creation in unix time.
update_time | The time of last update in unix time.
name | The unique name of the party.
user_count | The number of users in the party.

