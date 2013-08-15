## Install Guide

CouchDB and NodeJS should be installed. Latest stable versions are recommended.

CouchDB on port `5984` (default), Dashy runs on `4000`

1. Start CouchDB - This will differ depending on how you installed CouchDB. Check if its running `curl -X GET http://127.0.0.1:5984`. If you get a response, continue.
1. `$ git clone https://github.com/Wiredcraft/dashy.git`
2. `$ cd dashy`
3. `$ npm install`
4. `$ ./install/dashr`
5. `$ npm start`
6. `GOTO: http://127.0.0.1:4000`