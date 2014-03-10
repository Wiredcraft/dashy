library dashy_server;

import 'dart:io';
import 'package:redis_client/redis_client.dart';
import 'package:dashy/server/dashy_server.dart';
import 'package:uuid/uuid.dart';

const int PORT = 9223;


class DashyServer implements AbstractDashyServer {
  HttpServer httpServer;
  DashyRouter router;
  RedisClient redisClient;
  
  DashyServer(this.httpServer, this.router, this.redisClient);
}


main() {  
  HttpServer.bind('127.0.0.1', 1337)
    .then((server) {
      print("Dashy server is running on "
                   "'http://${server.address.address}:$PORT/'");
      
      RedisClient.connect('127.0.0.1:6379')
        .then((redis) => new DashyServer(server, 
            new DashyRouter(server, new TimedEventFlows(), new Uuid()), redis));
      
       });
  
  
}
  
  

