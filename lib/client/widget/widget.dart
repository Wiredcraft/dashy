library widget;

import 'package:dashy/client/grid/grid.dart';

/**
 * Contains information on the layout of the widget and which type it is.
 * Its "type" is inferred from the model variable.
 */
class Widget {
  var model;
  var id;

  Grid grid;

  get x => grid[id]['x'];

  get y => grid[id]['y'];

  get w => grid[id]['w'];

  get h => grid[id]['h'];

  Widget(this.model, this.id, this.grid);

}
