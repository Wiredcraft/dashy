library widget;

import 'package:angular/angular.dart';
import 'package:yaml/yaml.dart';

/**
 * Contains information on the layout of the widget and which type it is.
 * Its "type" is inferred from the model variable.
 */
class Widget {
  var configuration;

  List model;
  var id;
  List<String> dataSources = [];

  int x;
  int y;
  int w;
  int h;

  Widget(this.model, this.id, this.x, this.y, this.w, this.h, this.dataSources, this.configuration);

}
