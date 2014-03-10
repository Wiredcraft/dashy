library gauge_directive;


import 'dart:html';
import 'package:angular/angular.dart';
import 'package:dashy/client/lib/d3js.dart';

@NgDirective(
    selector: '[gauge-directive]'
)
class GaugeDirective {
  Element element;
  dynamic group;
  
  GaugeDirective(this.element, D3 d3) {
    print('directive');
    var d3Element = d3.select([element]);
    var width = 300;
    var height = 300;
    var svg = d3.append(['svg'], d3Element);
    group = d3.append(['g'], svg);
    d3.style('fill', 'red', svg);
    d3.attr('width', width, svg);
    d3.attr('height', height, svg);
    d3.attr('transform', 'translate(${width/2},${height/2})', group);
    d3.style('fill', 'red', group);
    d3.attr('width', width, group);
    d3.attr('height', height, group);
    
    
  }
}