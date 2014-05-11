library gauge_component;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:dashy/client/gauge/gauge.dart';
/**
 * The [GaugeComponent] is the glue between the view template and the model.
 */
@Component(
  selector: 'gauge',
  templateUrl: 'packages/dashy/client/gauge/gauge.html',
  publishAs: 'comp',
  map: const {
    'gauge' : '=>setGauge'
  },
  useShadowDom: false
)
class GaugeComponent {
  Element element;
  Scope scope;

  int get smallestDimension =>
    element.clientWidth < element.clientHeight?
    element.clientWidth : element.clientHeight;

  String get viewBox => '0 0 ${element.clientWidth} ${element.clientHeight}';

  Gauge gauge;

  GaugeComponent(this.element, this.scope);

  set setGauge(Gauge _gauge) {
    gauge = _gauge;
    scope.watch('smallestDimension', (newSmallestDimension,__){
      gauge.resize(newSmallestDimension);
    }, context: this);
  }
}

