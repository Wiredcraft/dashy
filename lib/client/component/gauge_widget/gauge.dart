library gauge_component;

import 'dart:html';
import 'package:angular/angular.dart';
import '../../model/widget.dart';
import '../../js_lib/d3js.dart';


@NgComponent(
    selector: 'gauge',
    publishAs: 'cmpt',
    templateUrl: 'packages/dashy/client/component/gauge_widget/gauge.html',
    cssUrl: 'packages/dashy/client/component/gauge_widget/gauge.css',
    map: const {
      'gaugeModel': '=>setGauge'
    }
)
class GaugeComponent {
  Gauge gauge;
  Element element;
  dynamic group;
  
  GaugeComponent(this.element, D3 d3) {
    var d3Element = d3.select([element.parent]);
    var width = 300;
    var height = 300;
    var svg = d3.append(['svg'], d3Element);
    group = d3.append(['g'], svg);
    d3.attr('fill', 'red', svg);
    d3.attr('width', width, svg);
    d3.attr('height', height, svg);
    d3.attr('transform', 'translate(${width/2},${height/2})', group);
    
  }
  
  set setGauge(Gauge model) {
    gauge = model;
  } 
}
