part of grid;


/**
 * The [GridPosition] helps find the position of a widget
 */
class GridPosition {
  Grid grid;

  GridPosition(this.grid);

  getX(widget) => grid[widget.id]['x'];

  getY(widget) => grid[widget.id]['y'];

  getW(widget) => grid[widget.id]['w'];

  getH(widget) => grid[widget.id]['h'];
}
