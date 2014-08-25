library dashy.graph_model;

import 'dart:async';
import 'dart:js';
import 'package:angular/angular.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';
import 'package:dashy/client/widget_factory/widget_factory.dart';
import 'package:d3/scale/scale.dart';

class Graph implements TimedEventAware {
  StreamController incomingTimedEvents = new StreamController();
  get d => dPathString();
  get areaD => areaDPathString();
  DateTime date;
  int firstEventTime = new DateTime.now().millisecondsSinceEpoch;
  int lastTime = new DateTime.now().millisecondsSinceEpoch;
  JsFunction areaFunc = context['d3']['svg']['area'].apply([]);
  String configuration;
  var width = 500;
  var height = 200;
  FirstTimeDecider firstTimeDecider = new FirstTimeDecider();

  get firstTime => firstTimeDecider(this);

  Duration duration;

  Linear xScale = new Linear();

  Linear yScale = new Linear();

  bool drawFromFirstEvent;

  List<TimedEvent> _events = new List<TimedEvent>();

  Graph({ this.drawFromFirstEvent: true, this.date, this.duration, this.configuration}) {
    incomingTimedEvents.stream.listen(update);
    rescaleRange();
  }

  toYaml() => configuration;

  addStream(stream) => incomingTimedEvents.addStream(stream);

  rescaleRange() {
    yScale..domain = [0, 100]
          ..clamp = true
          ..range = [height, 0];

    xScale..clamp = true
          ..range = [0, width];
  }

  areaDPathString() {

    areaFunc.callMethod('x', [(TimedEvent timedEvent, _) {
      return xScale(timedEvent.time.millisecondsSinceEpoch);
    }]);

    areaFunc.callMethod('y', [(TimedEvent timedEvent, _) {
      return yScale(timedEvent.data['value']);
    }]);

    areaFunc.callMethod('y0', [(TimedEvent timedEvent, _) {
      return yScale(0);
    }]);

    if (_events.isNotEmpty) {
      return areaFunc.apply([new JsArray.from(_events)]);
    }
  }

  dPathString() {
    var dString;
    if (_events.isNotEmpty) {
      dString = "M ${xScale(_events.first.time.millisecondsSinceEpoch)},${yScale(_events.first.data['value'])}";

      _events.skip(1).forEach((event) {
        dString += "L ${xScale(event.time.millisecondsSinceEpoch)},${yScale(event.data['value'])} ";
      });

    }
    return dString;
  }

  update(TimedEvent timedEvent) {
    const TIME_OFFSET = 100;
    maybeUpdateFirstAndLastTime(timedEvent);

    rescaleDomain(lastTime);

    var maxTimeBack = new DateTime.fromMillisecondsSinceEpoch(firstTime);

    _events.removeWhere((timedEvent) => timedEvent.time.isBefore(maxTimeBack.subtract(new Duration(seconds: TIME_OFFSET))));

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

  rescaleDomain(lastTime) {
    xScale.domain = [firstTime, lastTime];
  }

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
