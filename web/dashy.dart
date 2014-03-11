library dashy;

@MirrorsUsed(override: '*')
import 'dart:mirrors';

import 'package:angular/angular.dart';
import 'package:Dashy/client/dashy.dart';

void main() {
  
  ngBootstrap(module: new DashyModule());
}
