library widget_component_spec;

import 'dart:async';
import '../_specs.dart';
import 'package:dashy/client/widget/widget_component.dart';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/gauge/gauge_component.dart';
import 'package:dashy/client/gauge/gauge.dart';




main() {
  describe('widget', () {
    TestBed _;
    beforeEachModule((Module module) {
      module
        ..type(WidgetComponent)
        ..type(GaugeComponent);

      return (TestBed tb) => _ = tb;
    });

    it('component should display the type of component belonging to its model',
    async(
        inject((Scope scope, MockHttpBackend backend,Compiler compile,
                Injector injector, DirectiveMap directives) {
          var __ = new StreamController();

          Gauge gauge = new Gauge([__.stream]);
          gauge.value = 5;

          backend
            ..whenGET('packages/dashy/client/widget/widget.html').respond('''
            <gauge gauge="widg.model" probe="gp" ng-if="widg.isGauge()">
            </gauge>
        ''')
            ..whenGET('packages/dashy/client/gauge/gauge.html').respond('''
          <svg>
            {{comp.gauge.currentValue}}
            </svg>
        ''');

          var element = e('<widget model="g" probe="wp"></widget>');
          compile([element], directives)(injector, [element]);

          var context = _.rootScope.context;
          Probe widgetProbe = context['wp'];

          context['g'] = gauge;

          var widgetComponent = widgetProbe.directive(WidgetComponent);

          backend.flush();
          microLeap();

          _.rootScope.apply();
          Probe gaugeProbe = context['gp'];
          GaugeComponent gaugeComponent = gaugeProbe.directive(GaugeComponent);

          expect(gaugeComponent.gauge.currentValue).toBe(5);
        })));
  });

}

