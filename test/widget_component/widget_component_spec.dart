library widget_component_spec;

import 'dart:async';
import 'dart:js';
import '../_specs.dart';
import '../_test_module.dart';
import 'package:dashy/client/widget/widget_component.dart';
import 'package:dashy/client/gauge/gauge_component.dart';
import 'package:dashy/client/gauge/gauge.dart';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/grid/grid.dart';
import 'package:dashy/client/graph/graph.dart';
import 'package:dashy/client/app/app.dart';
import 'package:yaml/yaml.dart';



main() {
  describe('widget', () {
    TestBed _;
    beforeEachModule((Module module) {
      module..install(new MockDashyModule());

      return (TestBed tb) => _ = tb;
    });

    it('component should display the type of component belonging to its model',
    async(
        inject((Scope scope, MockHttpBackend backend, TestBed _, Grid grid) {
          var __ = new StreamController();
          Gauge gauge = new Gauge()..addStream(__.stream);

          Widget widget = new Widget(
              [gauge],
              0,
              0,
              0,
              0,
              0,
              null,
              null
          );



          backend
            ..whenGET('packages/dashy/client/widget/widget.html').respond(200,
          '''
            <div ng-repeat='model in widg.widget.model' class='body'>
              <gauge probe='gp' class='body'  gauge='model' ng-if='widg.isGauge'></gauge>
            </div>
        ''')
            ..whenGET('packages/dashy/client/gauge/gauge.html').respond(200,
          '''
            {{comp.gauge.currentValue}}
        ''');

          scope.context['gw'] = widget;
          Element element = e('<widget widget-model="gw" probe="wp"></widget>');

          _.compile(element);
          scope.apply();

          microLeap();
          backend.flush();
          microLeap();

          scope.apply();
          Probe widgetProbe = scope.context['wp'];

          var widgetComponent = widgetProbe.directive(WidgetComponent);
          scope.apply();
          Probe gaugeProbe = scope.context['gp'];

          GaugeComponent gaugeComponent = gaugeProbe.directive(GaugeComponent);
          expect(gaugeComponent).toBeNotNull();
        })));

    it('should switch to configuration view',
    async(
        inject((Scope scope, MockHttpBackend backend, TestBed _, Grid grid) {

          Widget widget = new Widget(
              [],
              0,
              0,
              0,
              0,
              0,
              null,
              null

          );

          backend
            ..whenGET('packages/dashy/client/widget/widget.html').respond(200,
          '''
<span ng-click='widg.displaying = !widg.displaying' probe='clp'>Config</span>
<div ng-repeat='model in widg.widget.model'>

</div>
<widget-configuration ng-if='!widg.displaying'></widget-configuration>
        ''')
            ..whenGET('packages/dashy/client/widget/configuration.html').respond(200,
          '''
<textarea  probe='cfp'>Configuring</textarea>
        ''');

          scope.context['gw'] = widget;
          var element = e('<widget widget="gw"></widget>');

          _.compile(element);
          scope.apply();

          microLeap();
          backend.flush();
          microLeap();
          scope.apply();
          Probe viewChangingClickableProbe = scope.context['clp'];


          _.triggerEvent(viewChangingClickableProbe.element, 'click', 'MouseEvent');

          microLeap();
          backend.flush();
          microLeap();
          Probe configProbe = scope.context['cfp'];
          expect(configProbe.element.innerHtml).toEqual('Configuring');
          clockTick(seconds:1);
        })));

    it('should display yaml string in config view',
    async(
        inject((Scope scope, MockHttpBackend backend, TestBed _, Grid grid) {
          var __ = new StreamController();

          Gauge gauge = new Gauge()..addStream(__.stream);
          gauge.value = 5;

          var widgetBefore = new Map.from(
              {   'id' : 'hello',
                  'type' :'Graph',
                  'settings': ['annyeong', 'haseyo']
              });

          Widget widget = new Widget(
              [gauge],
              null,
              0,
              0,
              0,
              0,
              [],
              widgetBefore
          );

          backend
            ..whenGET('packages/dashy/client/widget/widget.html').respond(200,
          '''
<span ng-click='widg.displaying = !widg.displaying' probe='clp'>Config</span>
<div ng-repeat='model in widg.widget.model'>

</div>
<widget-configuration configuration='widg.widget.configuration' ng-if='!widg.displaying'></widget-configuration>
        ''')
            ..whenGET('packages/dashy/client/widget/configuration.html').respond(200,
          '''
<textarea ng-blur='conf.updateWidget()' ng-model='conf.configuration' probe='cfp'></textarea>
        ''');

          scope.context['gw'] = widget;
          var element = e('<widget widget-model="gw"></widget>');

          _.compile(element);

          microLeap();
          backend.flush();
          microLeap();
          scope.apply();
          Probe viewChangingClickableProbe = scope.context['clp'];

          _.triggerEvent(viewChangingClickableProbe.element, 'click', 'MouseEvent');
          microLeap();
          backend.flush();
          microLeap();
          scope.apply();

          Probe configProbe = scope.context['cfp'];

          expect((configProbe.element as TextAreaElement).value).toEqual(
              '''id: hello
type: Graph
settings:
  - annyeong
  - haseyo
'''
          );
          clockTick(seconds:1);

        })));

    it('should update a widget when editted',
    async(
        inject((Scope scope, MockHttpBackend backend, TestBed _, Grid grid, App app) {
          var __ = new StreamController();

          Graph graph = new Graph()..addStream(__.stream);

          var widgetBefore = new Map.from(
              {   'type' :'Graph',
                  'datasources' : ['CPU', 'some-other'],
                  'settings': []
              });

          Widget widget = new Widget(
              [graph],
              'graph widget',
              0,
              0,
              0,
              0,
              [],
              widgetBefore
          );

          app.widgets.add(widget);

          backend
            ..whenGET('packages/dashy/client/widget/widget.html').respond(200,
          '''
<span ng-click='widg.displaying = !widg.displaying' probe='clp'>Config</span>
<div ng-repeat='model in widg.widget.model'>

</div>
<widget-configuration widget='widg.widget' configuration='widg.widget.configuration' ng-if='!widg.displaying'></widget-configuration>
        ''')
            ..whenGET('packages/dashy/client/widget/configuration.html').respond(200,
          '''
<button probe='savep' ng-click='conf.save()'>Save</button>
<textarea ng-model='conf.configuration' probe='cfp'></textarea>
        ''');

          scope.context['gw'] = widget;
          var element = e('<widget widget-model="gw"></widget>');

          _.compile(element);

          microLeap();
          backend.flush();
          microLeap();
          scope.apply();
          Probe viewChangingClickableProbe = scope.context['clp'];
          expect(app.widgets.length).toBe(4);

          _.triggerEvent(viewChangingClickableProbe.element, 'click', 'MouseEvent');

          microLeap();
          backend.flush();
          microLeap();
          scope.apply();

          Probe configProbe = scope.context['cfp'];
          InputTextLike textArea = configProbe.directive(InputTextLike);

          Probe saveClickProbe = scope.context['savep'];

          (configProbe.element as TextAreaElement).value =
'''
'graph widget':
  type: Graph
  datasources:
    - CPU
    - some-other
  settings:
    duration:
      seconds: 5''';

          textArea.processValue();

          _.triggerEvent(saveClickProbe.element, 'click', 'MouseEvent');

          var updatedWidget = app.widgets.firstWhere((w) => w.id == 'graph widget');
          expect(updatedWidget.model.first.duration).toEqual(new Duration(seconds:5));
          clockTick(seconds:1);
        })));


  });

}
