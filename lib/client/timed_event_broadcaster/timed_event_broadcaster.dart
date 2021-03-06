library dashy.timed_event_broadcaster;

import 'dart:async';
import 'package:angular/angular.dart';

part 'timed_event.dart';

/**
 * The [TimedEventBroadcaster] is responsible for coordinating the flow of new
 * [TimedEvent]s to the registered objects. It is a step in the configuration of a new
 * [WidgetModel] where it maps the [DataSource]s to [StreamController]s and
 * then listens to new [TimedEvent] on the [newMessages] [StreamController].
 */
@Injectable()
class TimedEventBroadcaster {
  Map<String, StreamController> dataSourceStreamControllers = new Map<String,
  StreamController>();
  StreamController newMessages = new StreamController.broadcast();

  TimedEventBroadcaster() {
    newMessages.stream.asBroadcastStream().listen(newTimedEvent);
  }

  StreamController registerDataSource(String dataSource) {
    dataSourceStreamControllers.putIfAbsent(dataSource, () {
      return new StreamController.broadcast();
    });

    return dataSourceStreamControllers[dataSource];
  }

  newTimedEvent(json) {
    TimedEvent timedEvent = new TimedEvent.fromJson(json);
    //TODO: paranoid programming: make sure timedEvent SC gets added on addition of widget
    if (dataSourceStreamControllers[timedEvent.dataSource] == null) dataSourceStreamControllers[timedEvent.dataSource] = new StreamController.broadcast();
    dataSourceStreamControllers[timedEvent.dataSource].add(timedEvent);
  }

}


abstract class TimedEventAware {
  addStream(Stream stream);
}
