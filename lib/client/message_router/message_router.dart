library message_router;

import 'dart:convert';
import 'package:angular/angular.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';


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
