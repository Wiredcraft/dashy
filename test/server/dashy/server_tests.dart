library dashy_server_tests;

import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:unittest/unittest.dart';
import 'package:dashy/server/dashy_server.dart';
import 'mocks/dashy_server_mock.dart';
import 'mocks/http_mock.dart';
import '../../jasmine_syntax.dart';



main() {
  DashyServerMock dashyServer;
  TimedEventFlows timedEventFlows;
  var controller, router, uuid;
  
  setUp(() {
    controller = new StreamController.broadcast();
    timedEventFlows = new TimedEventFlows();
    uuid = new UuidBase();
    router = new DashyRouter(controller.stream, timedEventFlows, 
                             uuid);
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
      
      it('should transform HttpRequests to WebSockets connections', () {
      //TODO (bbss) decide to test on server or mock out
      });
    });
    describe('key request handler', () {
      it('should respond with a unique ID for GET key-requests', () {
        
      });
      it('should deny requests with an existing ID' , () {
        
      });
    });
    
  });
}
