library widget_component_spec;

import 'dart:async';
import '../_specs.dart';
import '../_test_module.dart';
import 'package:dashy/client/widget/widget_component.dart';
import 'package:dashy/client/gauge/gauge_component.dart';
import 'package:dashy/client/gauge/gauge.dart';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/grid/grid.dart';



main() {
  describe('widget', () {
    TestBed _;
    beforeEachModule((Module module) {
      module..install(new MockDashyModule());

      return (TestBed tb) => _ = tb;
    });
  //TODO (bbss) fix broken test, loc in grid is null, loosen coupling
    it('component should display the type of component belonging to its model',
    async(
        inject((Scope scope, MockHttpBackend backend, TestBed _, Grid grid) {
          var __ = new StreamController();

          Gauge gauge = new Gauge()..addStream(__.stream);
          gauge.value = 5;

          Widget widget = new Widget(
              [gauge],
              null,
              grid
          );

          backend
            ..whenGET('packages/dashy/client/widget/widget.html').respond(200,
          '''
            <gauge gauge="widg.model" probe="gp" ng-if="widg.isGauge">
            </gauge>
        ''')
            ..whenGET('packages/dashy/client/gauge/gauge.html').respond(200,
          '''
            {{comp.gauge.currentValue}}
        ''');

//          scope.context['gw'] = widget;
//          var element = e('<widget widget="gw" probe="wp"></widget>');
//
//          _.compile(element);
//          scope.apply();
//
//          Probe widgetProbe = scope.context['wp'];
//          microLeap();
//          backend.flush();
//          microLeap();
//
//          var widgetComponent = widgetProbe.directive(WidgetComponent);
//          print(widgetComponent.model);
//
//          Probe gaugeProbe = scope.context['gp'];
//          GaugeComponent gaugeComponent = gaugeProbe.directive(GaugeComponent);
//          expect(gaugeComponent.gauge.currentValue).toBe(5);
        })));
  });

}

