library dashy_module;

import 'package:angular/angular.dart';
import 'package:Dashy/client/directive/gauge.dart';
import 'lib/d3js.dart';


class DashyModule extends Module {
  DashyModule(d3) {
    factory(D3, (_) => new D3(d3));
    type(GaugeDirective);
  }
}
