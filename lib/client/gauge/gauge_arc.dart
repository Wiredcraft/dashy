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
    element.classes.add('gauge-arc');

    var path = new PathElement();
    path.attributes['d'] = gauge.backgroundArcD;
    path.attributes['transform'] = 'translate(150, 150)';

    element.parent.insertBefore(path, element);

    scope.watch('d', (_new, _) {
      if(_new != null) {
        element.attributes['d'] = _new;
        element.attributes['transform'] = 'translate(150, 150)';
      }
    }, context: gauge, canChangeModel: false);
  }
}
