import 'dart:io';
import 'dart:async';
import 'package:route_hierarchical/server.dart';
import 'package:redis_client/redis_client.dart';
import 'package:dashy/server/content_types.dart';


class DashyServer {
  HttpServer _httpServer;
  DashyRouter _router;
  RedisClient _redisClient;
  
  DashyServer(this._httpServer, this._router, this._redisClient);  
}

class DashyRouter extends Router {
  DashyRouter(HttpServer server) : super(server) {
    defaultStream.listen(serveDirectory('web', as: '../../../../'));
     
  }
}

main() {
  HttpServer.bind('127.0.0.1', 1337)
  .then((server) {
    RedisClient.connect('127.0.0.1:6379')
    .then((redis) => new DashyServer(server, new DashyRouter(server), redis));
  }, onError: print);
  
}