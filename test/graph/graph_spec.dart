library graph_spec;


import '../_specs.dart';
import '../_test_module.dart';
import 'package:dashy/client/graph/graph.dart';
import 'package:dashy/client/widget_factory/widget_factory.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';
import 'package:yaml/yaml.dart';
import 'dart:async';
import 'dart:math';

main() {
  describe('graph', () {
    beforeEachModule((Module module) {
      module.install(new MockDashyModule());
    });

    iit('model should recalculate path on new value', async(() {
      var mockTimedEvents = new StreamController();

      Graph graph = new Graph();
      graph.addStream(mockTimedEvents.stream);
      var emptyModelD = graph.d;

      mockTimedEvents.add(new TimedEvent(null, null, new DateTime.now(), {
          "value" : null
      }, null));

      microLeap();

      var calculatedD = graph.d;
      expect(emptyModelD).not.toEqual(calculatedD);
    }));

    iit('model time scale should start at first event', async(() {
      var mockTimedEvents = new StreamController();

      Graph graph = new Graph();
      graph.addStream(mockTimedEvents.stream);

      mockTimedEvents.add(new TimedEvent(null, null, new DateTime.now(), {
          "value" :new Random().nextInt(100)
      }, null));
      microLeap();
      expect(graph.d.startsWith('M 0')).toBeTruthy();
    }));

    iit('should inject settings into widget', async(inject((WidgetFactory factory, TimedEventBroadcaster timedEventBroadcaster) {
      var graphConfig = '''
graph-widget-id:
  type: Graph
  attributes:
    - time-test
  settings:
    duration:
      seconds: 40
    drawFromFirstEvent: false
        ''';

      factory.newWidgets.stream.listen((widget) {
        microLeap();
        expect(widget.model.drawFromFirstEvent).toBeFalsy();
      });

      factory.createWidgetConfiguration(loadYaml(graphConfig));

    })));

    describe('scale start time should be configurable', () {
      const twentySeconds = const Duration(seconds: 20);
      const fortySeconds = const Duration(seconds: 40);

      var beginTime;

      var now = new DateTime.now();
      var nowInMs = now.millisecondsSinceEpoch;
      var twentySecondsAgoInMs = now.subtract(twentySeconds).millisecondsSinceEpoch;
      var fortySecondsAgoInMs = now.subtract(fortySeconds).millisecondsSinceEpoch;
      FirstTimeDecider firstTime = new FirstTimeDecider();

      it('should start at first event if no duration is specified', () {
        beginTime = firstTime.decideFirstTime(
          twentySecondsAgoInMs,
          now.millisecondsSinceEpoch,
          null,
          null,
          null
        );

        expect(beginTime).toBe(twentySecondsAgoInMs);
      });

      it('should start at the duration if specified', () {
        beginTime = firstTime.decideFirstTime(
            fortySecondsAgoInMs,
            now.millisecondsSinceEpoch,
            true,
            twentySeconds,
            null
        );

        expect(beginTime).toBe(twentySecondsAgoInMs);
      });

      it('should not start at the duration if first event is within duration', () {
        beginTime = firstTime.decideFirstTime(
            twentySecondsAgoInMs,
            now.millisecondsSinceEpoch,
            true,
            fortySeconds,
            null
        );

        expect(beginTime).not.toBe(fortySecondsAgoInMs);
      });

      it('should start at the first event if it is within duration and drawFromFirstEvent is true', () {
        beginTime = firstTime.decideFirstTime(
            twentySecondsAgoInMs,
            now.millisecondsSinceEpoch,
            true,
            fortySeconds,
            null
        );

        expect(beginTime).toBe(twentySecondsAgoInMs);
      });

      it('should start at the duration if the first event is within duration and drawFromFirstEvent is false', () {
        beginTime = firstTime.decideFirstTime(
            twentySecondsAgoInMs,
            now.millisecondsSinceEpoch,
            false,
            fortySeconds,
            null
        );

        expect(beginTime).toBe(fortySecondsAgoInMs);
      });

      it('should prefer to use a date if a duration is also specified', () {
        beginTime = firstTime.decideFirstTime(
            0,
            now.millisecondsSinceEpoch,
            false,
            twentySeconds,
            now.subtract(fortySeconds)
        );

        expect(beginTime).toBe(fortySecondsAgoInMs);
      });
    });
  });
}
