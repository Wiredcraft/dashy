library gauge_component_spect;

import '../_specs.dart';
import 'package:dashy/client/gauge/gauge_component.dart';
import 'package:dashy/client/gauge/gauge.dart';
import 'dart:async';



main() {
  describe('gauge', () {
    TestBed _;
    beforeEachModule((Module module) {
      module..type(GaugeComponent);

      return (TestBed tb) => _ = tb;
    });

    it('component should update percentage with data it gets from the model', async(
      inject((Scope scope, MockHttpBackend backend, VmTurnZone zone,
              Compiler compile,
              Injector injector, DirectiveMap directives) {
        var __ = new StreamController();

        Gauge gauge = new Gauge([__.stream]);
        gauge.value = 1;

        backend.whenGET('packages/dashy/client/gauge/gauge.html')
      .respond(
            '<svg>'
            '{{comp.gauge.currentValue}}'
            '</svg>'
        );

        var element = e('<gauge gauge="g" probe="i"></gauge>');
        compile([element], directives)(injector, [element]);

        var context = _.rootScope.context;
        Probe probe = context['i'];
        context['g'] = gauge;

        GaugeComponent gaugeComponent = probe.directive(GaugeComponent);

        backend.flush();
        microLeap();

        _.rootScope.apply();
        expect(gaugeComponent.gauge.currentValue).toBe(1);
        gauge.value = 99;
        expect(element).toHaveText('1');
        scope.apply();
        expect(element).toHaveText('99');
    })));

  });

}

