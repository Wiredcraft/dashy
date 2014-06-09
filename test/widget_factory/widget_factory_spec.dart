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
      const multipleWidgetYaml =
      '''widgets:
- gauge:
    datasources:
       - CPU
       - OTHER-SOURCE
    type: Gauge
    layout:
      x: 0
      y: 0
      w: 1
      h: 1
''';
          var widgets = widgetFactory.widgetsFromYaml(multipleWidgetYaml);
          expect(widgets.first.model.length).toBe(2);
        })));


    it('should update a widget', async(
        inject((WidgetFactory widgetFactory) {
          const multipleWidgetYaml =
          '''widgets:
- gauge:
    datasources:
       - CPU
       - OTHER-SOURCE
    type: Gauge
    layout:
      x: 0
      y: 0
      w: 1
      h: 1
''';
          var widgets = widgetFactory.widgetsFromYaml(multipleWidgetYaml);
          expect(widgets.first.model.length).toBe(2);
        })));
  });
}
