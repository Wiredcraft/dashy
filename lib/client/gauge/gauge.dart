library gauge;

import 'dart:async';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';

class Gauge {
  int _maxValue;
  int _minValue;
  int currentValue;
  
  Gauge(Iterable<Stream> timedEventStreams) {
    timedEventStreams.forEach((stream) => stream.listen(update));
  }

  update(TimedEvent timedEvent) {
    value = timedEvent.data['value'];
  }

  set value(int value) => currentValue = value;

}
