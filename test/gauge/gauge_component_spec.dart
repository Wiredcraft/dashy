library gauge_component_spect;

import '../_specs.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';
import 'package:dashy/client/gauge/gauge_component.dart';
import 'package:dashy/client/gauge/gauge.dart';
import 'dart:async';



main() {
  describe('gauge', () {
    TestBed _;
    Module module;
    beforeEachModule((Module _module) {
      module = _module;
      module..bind(GaugeComponent);
      return (TestBed tb) => _ = tb;
    });

    it('component should update percentage with data it gets from the model', async(
      inject((MockHttpBackend backend, VmTurnZone zone,
              Compiler compile, Injector injector,
              DirectiveMap directives) {
        var mockTimedEvents = new StreamController();
        var valueOne = new TimedEvent(null, null, null, {"value":1}, null);
        var valueTwo = new TimedEvent(null, null, null, {"value":2}, null);

        Gauge gauge = new Gauge()..addStream(mockTimedEvents.stream);

        backend.whenGET('packages/dashy/client/gauge/gauge.html')
        .respond(200,
        '{{comp.gauge.currentValue}}'
        );

        var element = _.compile('<gauge gauge="g" probe="i"></gauge>');



        var context = _.rootScope.context;
        Probe probe = context['i'];
        context['g'] = gauge;
        microLeap();
        backend.flush();
        microLeap();

        GaugeComponent gaugeComponent = probe.directive(GaugeComponent);

        _.rootScope.apply();
        mockTimedEvents.add(valueOne);
        microLeap();
        _.rootScope.apply();
        expect(element).toHaveText('1');
        mockTimedEvents.add(valueTwo);
        microLeap();
        expect(gaugeComponent.gauge.currentValue).toBe(2);
        _.rootScope.apply();
        expect(element).toHaveText('2');
    })));

  });

}

