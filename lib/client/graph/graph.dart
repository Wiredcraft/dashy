library graph;

import 'package:angular/angular.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';
import 'package:d3/scale/scale.dart';

@Injectable()
class Graph {
  get d => dPathString();
  DateTime firstTime = new DateTime.now();
  DateTime lastTime = new DateTime.now();
  Linear xScale = new Linear()
    ..clamp = true;

  List<TimedEvent> _events = new List<TimedEvent>();

  Graph(Iterable streams) {
    streams.forEach((stream) => stream.listen(add));
    xScale..range = [0, 200]
      ..domain = [firstTime.millisecondsSinceEpoch, lastTime.millisecondsSinceEpoch+10000];
  }

  dPathString() {
    var dString;
    if(_events.isNotEmpty) {
      dString = "M ${xScale(_events.first.time.millisecondsSinceEpoch)},${_events.first.data['value']}";

      _events.skip(1).forEach((event) {
        dString += "L ${xScale(event.time.millisecondsSinceEpoch)},${event.data['value']} ";
      });

    }
    return dString;
  }

  add(TimedEvent timedEvent) {
    if (_events.isEmpty) firstTime = timedEvent.time;
    if (lastTime.millisecondsSinceEpoch < timedEvent.time
    .millisecondsSinceEpoch) {
      lastTime = timedEvent.time;
    }
    _events.add(timedEvent);
  }
}
