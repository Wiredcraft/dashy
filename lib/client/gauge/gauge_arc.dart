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
      ..classes.add('background')
      ..attributes['d'] = gauge.backgroundArcD
      ..attributes['transform'] = 'translate(${element.clientWidth}, ${element.clientHeight})';

    element.classes.add('arc');
    element.parent.insertBefore(path, element);

    scope.watch('clientHeight', (_,__) {
      path.attributes['transform'] =
      'translate(${element.parent.clientWidth/2}, ${element.parent.clientHeight/2})';
      element.attributes['transform'] =
      'translate(${element.parent.clientWidth/2}, ${element.parent.clientHeight/2})';
    }, context: element.parent, canChangeModel: false);

    scope.watch('d', (_newD, _) {
      if (_newD != null) {
        element.attributes['d'] = _newD;
      }
    }, context: gauge, canChangeModel: false);

    scope.watch('backgroundArcD', (_newD, _) {
      if (_newD != null) {
        path.attributes['d'] = _newD;
      }
    }, context: gauge, canChangeModel: false);
  }
}
