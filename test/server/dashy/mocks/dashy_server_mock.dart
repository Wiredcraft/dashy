library dashy_server_mock;

import 'dart:async';
import 'dart:io';
import 'package:dashy/server/dashy_server.dart';

class DashyServerMock extends AbstractDashyServer {
  
  DashyServerMock(Stream<HttpRequest> httpServer, DashyRouter router, redisClient) 
  : super(httpServer, router, redisClient);
  
}
