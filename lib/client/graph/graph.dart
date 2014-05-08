library dashy.graph_model;

import 'package:angular/angular.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';
import 'package:d3/scale/scale.dart';

@Injectable()
class Graph {
  get d => dPathString();
  DateTime date;
  int firstEventTime = new DateTime.now().millisecondsSinceEpoch;
  int lastTime = new DateTime.now().millisecondsSinceEpoch;

  FirstTimeDecider firstTimeDecider = new FirstTimeDecider();

  get firstTime => firstTimeDecider(this);

  Duration duration;

  Linear xScale = new Linear()
    ..clamp = true
    ..range = [0, 500];

  bool drawFromFirstEvent;

  List<TimedEvent> _events = new List<TimedEvent>();

  Graph(Iterable streams, { this.drawFromFirstEvent: true, this.date, this.duration}) {
    streams.forEach((stream) => stream.listen(update));
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

  update(TimedEvent timedEvent) {
    maybeUpdateFirstAndLastTime(timedEvent);

    rescale(lastTime);

    var maxTimeBack = new DateTime.fromMillisecondsSinceEpoch(firstTime);

    _events.removeWhere((timedEvent) => timedEvent.time.isBefore(maxTimeBack));

    _events.add(timedEvent);

    return _events;
  }

  maybeUpdateFirstAndLastTime(TimedEvent timedEvent) {
    var timedEventTime = timedEvent.time.millisecondsSinceEpoch;
    if (_events.isEmpty) firstEventTime = timedEventTime;
    if (lastTime < timedEventTime) {
      lastTime = timedEventTime;
    }
  }

  rescale(lastTime) =>
    xScale.domain = [firstTime, lastTime];

}

//decide whether the first time of the scale should be the first event or from a moment
class FirstTimeDecider {
  call(Graph graph) => decideFirstTime(
      graph.firstEventTime,
      graph.lastTime,
      graph.drawFromFirstEvent,
      graph.duration,
      graph.date
  );

  decideFirstTime(int firstEventTime, int lastTime, bool drawFromFirstEvent, Duration duration, DateTime date) {
    var timeBack;

    if (date != null) {
      timeBack = lastTime - date.millisecondsSinceEpoch;
    } else if (duration != null) {
      timeBack = duration.inMilliseconds;
    }

    if (timeBack != null) {
      var durationMoment = lastTime - timeBack;
      if (firstEventTime <= durationMoment) return durationMoment;
      if (firstEventTime > durationMoment && !drawFromFirstEvent) return durationMoment;
    }

    return firstEventTime;
  }

}
