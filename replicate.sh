curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicate -d ' {"source": "http://192.168.1.26:5984/widgets", "target": "widgets", "create_target":true} '

curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicate -d ' {"source": "http://192.168.1.26:5984/sources", "target": "sources", "create_target":true} '

curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicate -d ' {"source": "http://192.168.1.26:5984/pictures", "target": "pictures", "create_target":true} '

curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicate -d ' {"source": "http://192.168.1.26:5984/internet", "target": "internet", "create_target":true} '

curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicate -d ' {"source": "http://192.168.1.26:5984/githubrepos", "target": "githubrepos", "create_target":true} '

curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicate -d ' {"source": "http://192.168.1.26:5984/commits", "target": "commits", "create_target":true} '

curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicate -d ' {"source": "http://192.168.1.26:5984/builds", "target": "builds", "create_target":true} '