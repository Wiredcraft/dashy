library dashy_server_tests;

import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:io';
import 'package:unittest/unittest.dart';
import 'package:dashy/server/dashy_server.dart';
import 'mocks/dashy_server_mock.dart';
import 'mocks/http_mock.dart';
import '../../jasmine_syntax.dart';



main() {
  DashyServerMock dashyServer;
  TimedEventFlows timedEventFlows;
  var controller, router;
  
  setUp(() {
    controller = new StreamController<HttpRequest>.broadcast();
    timedEventFlows = new TimedEventFlows();
    router = new DashyRouter(controller.stream, timedEventFlows);
    dashyServer = new DashyServerMock(controller.stream, router, null);
  });
  
  describe('Dashy Servers', () {
    describe('Dashy Router', () {
      const DATASOURCE_TOKEN = 1337;
      it("should convert calls to API to TimedEvents", () {
        var apiCall = new HttpRequestMock(Uri.parse('/event/$DATASOURCE_TOKEN'),
            method: 'POST');
        
        controller.add(apiCall);
        });
    });
  });
  
}
