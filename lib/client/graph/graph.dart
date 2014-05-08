library dashy.graph_model;

import 'package:angular/angular.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';
import 'package:d3/scale/scale.dart';
import 'dart:collection';

@Injectable()
class Graph {
  get d => dPathString();
  DateTime date;
  int firstTime = new DateTime.now().millisecondsSinceEpoch;
  int lastTime = new DateTime.now().millisecondsSinceEpoch;
  Duration duration;
  GraphTimeScale xScale = new GraphTimeScale();

  bool drawFromFirstEvent;


  List<TimedEvent> _events = new List<TimedEvent>();

  Graph(Iterable streams, { this.drawFromFirstEvent: true, this.date, this.duration}) {
    streams.forEach((stream) => stream.listen(add));

  }

  dPathString() {
    var dString;
    if (_events.isNotEmpty) {
      dString = "M ${xScale(_events.first.time.millisecondsSinceEpoch)},${_events.first.data['value']}";

      _events.skip(1).forEach((event) {
        dString += "L ${xScale(event.time.millisecondsSinceEpoch)},${event.data['value']} ";
      });

    }
    return dString;
  }

  add(TimedEvent timedEvent) {
    maybeUpdateFirstAndLastTime(timedEvent);

    xScale.rescale(firstTime, lastTime, drawFromFirstEvent, duration, date);

    _events.add(timedEvent);

    return _events;
  }

  maybeUpdateFirstAndLastTime(TimedEvent timedEvent) {
    var timedEventTime = timedEvent.time.millisecondsSinceEpoch;
    if (_events.isEmpty) firstTime = timedEventTime;
    if (lastTime < timedEventTime) {
      lastTime = timedEventTime;
    }
  }
}

class GraphTimeScale {
  Linear linear = new Linear()
    ..clamp = true
    ..range = [0, 500];

  call(x) => linear.call(x);

  rescale(int firstTime, int lastTime, drawFromFirstEvent, duration, DateTime date) {
    linear.domain = [decideFirstTime(firstTime, lastTime, drawFromFirstEvent, duration, date), lastTime];

    return linear;
  }

  //decide whether the first time of the scale should be the first event or from a moment
  decideFirstTime(int firstTime, int lastTime, bool drawFromFirstEvent, Duration duration, DateTime date) {
    var timeBack;

    if (date != null) {
      timeBack = lastTime - date.millisecondsSinceEpoch;
    } else if (duration != null) {
      timeBack = duration.inMilliseconds;
    }

    if (timeBack != null) {
      var durationMoment = lastTime - timeBack;
      if (firstTime <= durationMoment) return durationMoment;
      if (firstTime > durationMoment && !drawFromFirstEvent) return durationMoment;
    }

    return firstTime;
  }
}
