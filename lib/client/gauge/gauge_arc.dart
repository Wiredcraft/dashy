library gauge_arc;

import 'dart:html';
import 'dart:svg';
import 'package:angular/angular.dart';
import 'package:dashy/client/gauge/gauge.dart';


@Decorator(
    selector: '[gauge]',
    map: const {
        'gauge-model' : '=>setGauge'
    }
)
class GaugeArc {
  Element element;
  Scope scope;
  Gauge gauge;

  GaugeArc(this.element, this.scope);

  set setGauge(_gauge) {
    gauge = _gauge;
    var path = new PathElement()
      ..classes.add('background')
      ..attributes['d'] = gauge.backgroundArcD
      ..attributes['transform'] = 'translate(${element.clientWidth}, ${element.clientHeight})';

    element.classes.add('arc');
    element.parent.insertBefore(path, element);
    scope.context['element'] = element;
    scope.context['gauge'] = gauge;
    scope.watch('element.parent.clientHeight', (_,__) {
      path.attributes['transform'] =
      'translate(${element.parent.clientWidth/2}, ${element.parent.clientHeight/2})';
      element.attributes['transform'] =
      'translate(${element.parent.clientWidth/2}, ${element.parent.clientHeight/2})';
    });

    scope.watch('gauge.d', (_newD, _) {
      if (_newD != null) {
        element.attributes['d'] = _newD;
      }
    });

    scope.watch('gauge.backgroundArcD', (_newD, _) {
      if (_newD != null) {
        path.attributes['d'] = _newD;
      }
    });
  }
}
