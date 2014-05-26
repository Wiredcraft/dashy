library gauge;

import 'dart:async';
import 'dart:js';
import 'dart:math';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';

const TAU =  PI * 2;

/**
 * The [Gauge] class is responsible for updating the Gauge type components
 * model in an appropriate manner.
 */
class Gauge {
  int _maxValue;
  int _minValue;
  int currentValue;
  int smallestDimension;
  StreamController incomingTimedEvents = new StreamController();

  JsFunction arc = context['d3']['svg']['arc'].apply(null);
  JsFunction backgroundArc = context['d3']['svg']['arc'].apply(null);
  
  Gauge() {
    incomingTimedEvents.stream.listen(update);
  }

  addStream(Stream stream) => incomingTimedEvents.addStream(stream);

  resize(smallestDimension) {
    arc..callMethod('innerRadius', [smallestDimension / 2 * 0.9])
      ..callMethod('outerRadius', [smallestDimension / 2 * 0.85])
      ..callMethod('startAngle', [-0.37 * TAU]);

    backgroundArc..callMethod('innerRadius', [smallestDimension / 2 * 0.9])
      ..callMethod('outerRadius', [smallestDimension / 2 * 0.85])
      ..callMethod('startAngle', [-0.37 * TAU])
      ..callMethod('endAngle', [0.37 * TAU]);
  }

  update(TimedEvent timedEvent) {
    value = timedEvent.data['value'];
  }

  get d => dPathString();
  get backgroundArcD => backgroundArc.apply(null);

  dPathString() {
    var dString;
    if (currentValue != null) {
      arc.callMethod('endAngle', [currentValue/100 * TAU * 0.74 - TAU * 0.37]);
      dString = arc.apply(null);
    }
    return dString;
  }

  set value(int value) => currentValue = value;

}
