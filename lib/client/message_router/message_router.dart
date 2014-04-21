library dashy.message_router;

import 'dart:convert';
import 'package:angular/angular.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';

/**
 * The [MessageRouter] is responsible for sending the incoming messages from
 * the right recipient. For instance on a new "update" type message from the
 * [WebSocketsWrapper], this will send a new [TimedEvent] to the
 * [TimedEventBroadcaster].
 */
@Injectable()
class MessageRouter {
  TimedEventBroadcaster timedEventBroadcaster;

  MessageRouter(this.timedEventBroadcaster);

  call(message) {
    var json = JSON.decode(message.data);
    var type = json['type'];
    switch (type) {
      case 'update':
      timedEventBroadcaster.newTimedEvent(json);
    }
  }
}
