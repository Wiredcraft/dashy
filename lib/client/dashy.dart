library dashy_module;

import 'dart:html';
import 'dart:convert';
import 'dart:async';
import 'package:angular/angular.dart';
import 'package:Dashy/client/directive/gauge.dart';


class DashyModule extends Module {
  DashyModule() {
    type(GaugeDirective);
    connect();
  }
}


bool connectPending = false;
WebSocket webSocket;

const Duration RECONNECT_DELAY = const Duration(milliseconds: 500);

void connect() {
  connectPending = false;
  webSocket = new WebSocket('ws://${Uri.base.host}:${Uri.base.port}/ws');
  webSocket.onOpen.first.then((_) {
    onConnected();
    webSocket.onClose.first.then((_) {
      print("Connection disconnected to ${webSocket.url}.");
      onDisconnected();
    });
  });
  webSocket.onError.first.then((_) {
    print("Failed to connect to ${webSocket.url}. "
          "Run bin/server.dart and try again.");
    onDisconnected();
  });
}

void onConnected() {
  webSocket.onMessage.listen((e) {
    handleMessage(e.data);
  });
}

void onDisconnected() {
  if (connectPending) return;
  connectPending = true;
  print('Disconnected. Start \'bin/server.dart\' to continue.');
  new Timer(RECONNECT_DELAY, connect);
}

void handleMessage(data) {
  var json = JSON.decode(data);
  var response = json['response'];
  switch (response) {
    case 'CPU':
      print(response);
            break;

    default:
      print("Invalid response: '$response'");
  }
}