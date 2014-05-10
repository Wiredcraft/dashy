library gauge_arc;

import 'dart:html';
import 'dart:svg';
import 'package:angular/angular.dart';


@Decorator(
    selector: '[gauge]',
    map: const {
        'gauge-model' : '=>gauge'
    }
)
class GaugeArc {
  Element element;
  Scope scope;

  GaugeArc(this.element, this.scope);

  set gauge(gauge) {
    var path = new PathElement()
      ..classes.add('gauge-arc-background')
      ..attributes['d'] = gauge.backgroundArcD
      ..attributes['transform'] = 'translate(150, 150)';

    element.classes.add('gauge-arc');
    element.parent.insertBefore(path, element);

    scope.watch('d', (_new, _) {
      if(_new != null) {
        element.attributes['d'] = _new;
        element.attributes['transform'] = 'translate(150, 150)';
      }
    }, context: gauge, canChangeModel: false);
  }
}
