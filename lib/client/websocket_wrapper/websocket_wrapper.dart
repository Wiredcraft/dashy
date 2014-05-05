library dashy.websocket_wrapper;

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:dashy/client/message_router/message_router.dart';

const RECONNECT_DELAY = 500;

/**
 * The [WebSocketWrapper] has the responsibility of keeping the messages from
 * the back-end flowing to the [MessageRouter]. It maintains the connection
 * and deserializes incoming messages before sending them of to the
 * [MessageRouter]
 */
@Injectable()
class WebSocketWrapper {
  bool connectPending = false;
  StreamController incomingMessageStream;
  WebSocket webSocket;

  WebSocketWrapper(MessageRouter messageRouter, this.incomingMessageStream) {
    incomingMessageStream.stream.listen(messageRouter);
    connect();
  }

  registerWebSocketStream(Stream webSocketsStream) {
    var splitStringStream = webSocketsStream.transform(UTF8.encoder)
                                            .transform(const LineSplitter());

    incomingMessageStream.addStream(splitStringStream);
  }

  connect() {
    webSocket  = new WebSocket('ws://${Uri.base.host}:8081/ws');
    webSocket.onOpen.first.then((_){
      incomingMessageStream.addStream(webSocket.onMessage);
      webSocket.onClose.first.then((_) {
        onDisconnected();
        print("Failed to connect to ${webSocket.url}. "
        "Reconnecting");
      });
    });
    webSocket.onError.listen((e) {
      print("Error on ${webSocket.url} -  $e");
      onDisconnected();
    });
  }

  onDisconnected() {
    if(connectPending) return;
    connectPending = true;
    new Timer(new Duration(milliseconds: RECONNECT_DELAY), connect);
  }
}
