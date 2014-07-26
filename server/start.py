#!/bin/python2

from app import server
from OpenSSL import SSL

context = SSL.Context(SSL.SSLv23_METHOD)
context.use_privatekey_file("credentials/server.key")
context.use_certificate_file("credentials/server.crt")

server.run(ssl_context=context, debug=True)
