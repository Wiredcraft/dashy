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

  Gauge gauge;

  GaugeComponent(this.element);

  set setGauge(Gauge _gauge) {
    gauge = _gauge;
  }

}

