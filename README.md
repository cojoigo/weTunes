weTunes
=======

Software Engineering 1 project

Bugs
---
A list of known bugs can be found in the bugs.txt file.


Networking
---
To interface with the RESTful web server, the client networking module uses an iOS framework called RestKit. RestKit has a powerful Object Mapping functionality that maps the response object to a corresponding object on the client’s side. In this way, we ensure that the data we store on the device is the same as the data stored on the server. RestKit’s RKObjectManager class takes care of the mapping and the actual sending of requests to the web server.
The methods critical to the application’s performance are found in the XYZServerCommunication.m file. These include: createUser(), createParty(), joinParty(), updateParty(), refreshParty(), and vote(). Each one functions almost exactly the same, with the only changes being the URL the request is sent to and the data being sent. They all use a POST request that updates either the User class or the Party class with new information from the server or with information included in the POST request. For createUser, the User class is populated with unique identifiers necessary to call the rest of the methods on the server. The rest of the methods update the Party class with information related to the current party, including vote count and song data.


Server
---
See the README.md file in the server directory.
