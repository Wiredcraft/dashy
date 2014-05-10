library timed_event_broadcaster_spec;

import '../_specs.dart';
import '../_test_module.dart';
import 'package:unittest/unittest.dart' as unit;
import 'dart:async';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';
import 'package:dashy/client/gauge/gauge.dart';


main() {
  describe('timed event broadcaster', () {
    const DATASOURCE_NAME = 'some-datasource';

    TestBed _;

    beforeEachModule((Module module) {
      module.install(new MockDashyModule());

      return (TestBed tb) => _ = tb;
    });

    it('should update the model on receiving a new update message', async(() {
      inject((TimedEventBroadcaster timedEventBroadcaster) {
        StreamController mockNewMessages = timedEventBroadcaster.newMessages;

        var timedEventStream = timedEventBroadcaster.registerDataSource('some-datasource').stream.asBroadcastStream();

        Gauge gauge = new Gauge([timedEventStream]);

        mockNewMessages.add({
            "time" : new DateTime.now().toIso8601String(), "datasource" : "some-datasource", "data" : {
                "value" : 2
            }
        });

        timedEventStream.first.then((timedEvent) {
          mockNewMessages.close();
        });

        var asyncExpectation = unit.expectAsync(() {
          expect(gauge.currentValue).toBe(2);
        });
        mockNewMessages.stream.listen((_) {
        }, onDone: asyncExpectation);

      });
    }));
  });
}
