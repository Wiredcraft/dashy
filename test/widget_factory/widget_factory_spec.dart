library widget_factory_spec;

import '../_specs.dart';
import '../_test_module.dart';
import 'dart:async';
import 'dart:convert';
import 'package:unittest/unittest.dart' as unit;
import 'package:yaml/yaml.dart';
import 'package:dashy/client/widget_factory/widget_factory.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';
import 'package:dashy/client/gauge/gauge.dart';
import 'package:dashy/client/widget/widget.dart';

main() {
  describe('widget factory', () {
    const DATASOURCE_NAME = 'some-datasource';

    TestBed _;

    beforeEachModule((Module module) {
      module..install(new MockDashyModule());

      return (TestBed tb) => _ = tb;
    });

    it('should create a widget', async(
        inject((WidgetFactory widgetFactory,
                TimedEventBroadcaster timedEventFactory) {

          const configYaml =
'''widgets:
   - some-widget-id:
       attributes:
         some-attribute:
           $DATASOURCE_NAME: some-attribute-on-datasource
       type: Gauge
''';

          var asyncExpectation = unit.expectAsync((element) {
            expect(element.runtimeType).toBe(Widget);
            expect(element.model.runtimeType).toBe(Gauge);
          }, count: 1);

          widgetFactory.newWidgets.stream.listen(asyncExpectation);
          widgetFactory.widgetsFromYaml(configYaml);

        })));
  });
}
