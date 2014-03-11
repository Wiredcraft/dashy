library dashy_server;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http_server/http_server.dart';
import 'package:route/server.dart';
import 'package:path/path.dart' as path;
import 'package:dashy/common/timed_event.dart';
import 'package:uuid/uuid.dart';


part 'dashy_router.dart';
part 'timed_event_flows.dart';
part 'content_types.dart';


abstract class AbstractDashyServer {
  Stream httpServer;
  DashyRouter router;
  dynamic redisClient;
  
  AbstractDashyServer(this.httpServer, this.router, this.redisClient);
  
}

