library dashy_server_tests;

import 'dart:async';
import 'dart:html' as Http;
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
    uuid = new Uuid();
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
//         var webSocket = new Http.WebSocket
//             ('ws://${Uri.base.host}:${Uri.base.port}/ws');
//         TODO (bbss) work on mockHttpRequest or spin up server with actual client
        
      });
    });

    
  });
}
