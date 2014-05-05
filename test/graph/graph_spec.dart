library graph_spec;


import '../_specs.dart';
import 'package:dashy/client/graph/graph.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';
import 'dart:async';
import 'dart:math';

main() {
  describe('graph', () {
    it('model should recalculate path on new value', async(() {
      var mockTimedEvents = new StreamController();

      Graph graph = new Graph([mockTimedEvents.stream]);

      var emptyModelD = graph.d;

      mockTimedEvents.add(new TimedEvent(null, null, new DateTime.now(), { "value" : null}));

      microLeap();

      var calculatedD = graph.d;
      expect(emptyModelD).not.toEqual(calculatedD);
    }));

    it('model time scale should start at first event', async(() {
      var mockTimedEvents = new StreamController();

      Graph graph = new Graph([mockTimedEvents.stream]);

      mockTimedEvents.add(new TimedEvent(null, null, new DateTime.now(), { "value" :new Random().nextInt(100)}));
      microLeap();
      expect(graph.d.startsWith('M 0')).toBeTruthy();
    }));

    it('model should adjust the time to a given duration', () {

    });

  });
}
