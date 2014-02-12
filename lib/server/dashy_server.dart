library dashy_server;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:route_hierarchical/server.dart';
import 'package:path/path.dart' as path;
import 'package:dashy/common/timed_event.dart';


part 'dashy_router.dart';
part 'timed_event_flows.dart';
part 'content_types.dart';


abstract class AbstractDashyServer {
  Stream httpServer;
  DashyRouter router;
  dynamic redisClient;
  
  AbstractDashyServer(this.httpServer, this.router, this.redisClient);
  
}

