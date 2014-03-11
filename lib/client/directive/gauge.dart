library gauge_directive;


import 'dart:html';
import 'package:angular/angular.dart';


@NgDirective(
    selector: '[gauge-directive]'
)
class GaugeDirective {
  Element element;
  dynamic group;
  
  GaugeDirective(this.element) {
    
  }
}