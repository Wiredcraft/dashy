library widget;

import 'package:dashy/client/grid/grid.dart';

/**
 * Contains information on the layout of the widget and which type it is.
 * Its "type" is inferred from the model variable.
 */
class Widget {
  var model;
  var id;

  GridPosition gridPositioner;

  get x => gridPositioner.getX(this);

  get y => gridPositioner.getY(this);

  get w => gridPositioner.getW(this);

  get h => gridPositioner.getH(this);

  Widget(this.model, this.id, this.gridPositioner);

}
