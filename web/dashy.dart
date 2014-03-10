library dashy;

import 'dart:js';
import 'package:angular/angular.dart';
import 'package:dashy/client/dashy.dart';

void main() {
  var d3 = context['d3'];
  
  ngBootstrap(module: new DashyModule(d3));
}
