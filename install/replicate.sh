#!/bin/bash

SOURCE="192.168.1.26"
PORT="5984"

echo "replicating databases..."

curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicate -d ' {"source": "http://$SOURCE:$PORT/widgets", "target": "widgets", "create_target":true} '

curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicate -d ' {"source": "http://$SOURCE:$PORT/sources", "target": "sources", "create_target":true} '

curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicate -d ' {"source": "http://$SOURCE:$PORT/pictures", "target": "pictures", "create_target":true} '

curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicate -d ' {"source": "http://$SOURCE:$PORT/internet", "target": "internet", "create_target":true} '

curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicate -d ' {"source": "http://$SOURCE:$PORT/githubrepos", "target": "githubrepos", "create_target":true} '

curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicate -d ' {"source": "http://$SOURCE:$PORT/commits", "target": "commits", "create_target":true} '

curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicate -d ' {"source": "http://$SOURCE:$PORT/builds", "target": "builds", "create_target":true} '

echo "databases replicated"