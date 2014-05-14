library widget;

import 'package:dashy/client/grid/grid.dart';
import 'package:angular/angular.dart';

/**
 * Contains information on the layout of the widget and which type it is.
 * Its "type" is inferred from the model variable.
 */
class Widget {
  dynamic model;
  var id;

  Grid grid;

  int x() => grid[id]['x'];

  int y() => grid[id]['y'];

  int w() => grid[id]['w'];

  int h() => grid[id]['h'];

  Widget(this.model, this.id, this.grid);

}
