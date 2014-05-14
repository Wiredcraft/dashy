library grid_spec;

import '../_specs.dart';
import '../_test_module.dart';
import 'package:unittest/unittest.dart' as unit;
import 'dart:async';
import 'package:yaml/yaml.dart';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/widget_factory/widget_factory.dart';
import 'package:dashy/client/grid/grid.dart';


main() {
  describe('grid', () {

    TestBed _;

    beforeEachModule((Module module) {
      module.install(new MockDashyModule());

      return (TestBed tb) => _ = tb;
    });

    it('position should find the location of a widget', async(
    inject((Grid grid, WidgetFactory widgetFactory) {
      var conf = '''
some-widget:
   attributes:
     value:
       DS: value
   type: Gauge
   layout:
     x: 1
     y: 2
     w: 1
     h: 1
      ''';

      widgetFactory.newWidgets.stream.listen((widget) {
        expect(widget.x()).toBe(1);
        expect(widget.y()).toBe(2);
      });

      var widgetConfiguration = widgetFactory.createWidgetConfiguration(loadYaml(conf));
      widgetFactory.grid.regenerateGrid(items: [widgetConfiguration]);
      widgetFactory.broadcastWidget(widgetConfiguration);

    })));

  });
}
