library dashy;

@MirrorsUsed(override: '*')
import 'dart:mirrors';
import 'package:angular/angular.dart';
import 'package:dashy/client/dashy.dart';

void main() {
  applicationFactory()
    .addModule(new DashyModule())
    .run();
}
