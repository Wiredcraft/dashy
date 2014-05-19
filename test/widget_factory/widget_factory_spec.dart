library widget_factory_spec;

import '../_specs.dart';
import '../_test_module.dart';
import 'package:unittest/unittest.dart' as unit;
import 'package:dashy/client/widget_factory/widget_factory.dart';
import 'package:dashy/client/gauge/gauge.dart';
import 'package:dashy/client/widget/widget.dart';

main() {
  describe('widget factory', () {
    const DATASOURCE_NAME = 'some-datasource';
    const OTHER_DATASOURCE_NAME = 'some-datasource';

    TestBed _;

    beforeEachModule((Module module) {
      module..install(new MockDashyModule());

      return (TestBed tb) => _ = tb;
    });

    it('should create a widget with multiple sources', async(
        inject((WidgetFactory widgetFactory) {

          const configYaml =
'''
widgets:
 - some-widget-id:
     attributes:
       - $DATASOURCE_NAME
       - $OTHER_DATASOURCE_NAME
     type: Gauge
''';

          var asyncExpectation = unit.expectAsync((element) {
            expect(element.runtimeType).toBe(Widget);
            expect(element.model is Iterable).toBeTruthy();
          }, count: 1);

          widgetFactory.newWidgets.stream.listen(asyncExpectation);
          widgetFactory.widgetsFromYaml(configYaml);
        })));
  });
}
