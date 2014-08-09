get_parties
=====================

Overview
---------------------
This provides a method to get the information for all parties on the server.

### URL
https://sgoodwin.pythonanywhere.com/get_parties

### Allowed Methods
GET

### Authentication
HTTP Basic, with user_id and user_password.


### Response
A list of parties where each has the following:

Name | Value
-----|------
id | The unique id for the party.
song_data | The song data, including the vote counts.
creation_time | The time of creation in unix time.
update_time | The time of last update in unix time.
name | The unique name of the party.
user_count | The number of users in the party.

