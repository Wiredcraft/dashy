library status_spec;


import '../_specs.dart';
import '../_test_module.dart';
import 'package:dashy/client/widget_factory/widget_factory.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';
import 'package:yaml/yaml.dart';
import 'dart:async';
import 'dart:math';

main() {
  describe('status', () {
    beforeEachModule((Module module) {
      module.install(new MockDashyModule());
    });

    it('should inject settings into widget', async(
        inject((WidgetFactory factory, TimedEventBroadcaster timedEventBroadcaster) {
      var statusConfig = '''
status-widget-id:
  type: Status
  attributes:
    value:
      time-test: value
        ''';

      factory.newWidgets.stream.listen((widget) {
        microLeap();
        print(widget.model.runtimeType);
        expect(widget.model);
      });

      factory.createWidget(loadYaml(statusConfig));

    })));
  });
}
