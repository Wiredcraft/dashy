library dashy_server;

import 'dart:io';
import 'dart:async';
import 'package:redis_client/redis_client.dart';
import 'package:dashy/server/dashy_server.dart';
import 'package:uuid/uuid.dart';


class DashyServer implements AbstractDashyServer {
  HttpServer httpServer;
  DashyRouter router;
  RedisClient redisClient;
  
  DashyServer(this.httpServer, this.router, this.redisClient);  
}


main() {
  startServer();
}

startServer() {
  HttpServer.bind('127.0.0.1', 1337)
    .then((server) {
      RedisClient.connect('127.0.0.1:6379')
        .then((redis) => new DashyServer(server, new DashyRouter(server, new TimedEventFlows(), new Uuid()), redis));
      });
}
