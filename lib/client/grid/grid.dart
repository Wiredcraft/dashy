library grid;

import 'dart:math';
import 'package:di/di.dart';
import 'package:angular/angular.dart';


class GridModule extends Module {
  GridModule() {
    bind(Grid);
    bind(NullingColumn);
    bind(MinRows);
  }
}

@Injectable()
class Grid {
  Map<int, Map> rows = new Map();
  Map<int, Map> columns = new Map();
  Map<Object, Set<Point>> objectLocations = new Map();

  int get maxRow {
    var currentMaxRow;
    if (rows.isNotEmpty) currentMaxRow = rows.keys.reduce(max) + 1;;
    if (currentMaxRow != null && currentMaxRow >= minRows.rows) return currentMaxRow;
    return minRows.rows;
  }

  MinRows minRows;

  NullingColumn nullingColumn;

  Grid(this.nullingColumn, this.minRows);

  addAll(Map<Object, Rectangle> contents) {
    contents.forEach((object, at) => add(object, at: at));
  }

  clear(Rectangle rectangle) {
    for (var columnNumber = rectangle.left ; columnNumber < rectangle.left + rectangle.width ; columnNumber++) {
      for (var rowNumber = rectangle.top ; rowNumber < rectangle.bottom  ; rowNumber++) {
        columns[columnNumber].remove(rowNumber);
        if (columns[columnNumber].isEmpty) columns.remove(columnNumber);
        rows[rowNumber].remove(columnNumber);
        if (rows[rowNumber].isEmpty) rows.remove(rowNumber);
      }
    }
  }

  addObjectAtArea(object, rectangle) {
    objectLocations.putIfAbsent(object, () => new Set());
    for (var columnNumber = rectangle.left ; columnNumber < rectangle.left + rectangle.width ; columnNumber++) {
      columns.putIfAbsent(columnNumber, () => new Map());
      for (var rowNumber = rectangle.top ; rowNumber < rectangle.bottom  ; rowNumber++) {
        rows.putIfAbsent(rowNumber, () => new Map());
        columns[columnNumber][rowNumber] = object;
        rows[rowNumber][columnNumber] = object;
        objectLocations[object].add(new Point(columnNumber, rowNumber));
      }
    }
  }

  remove(object) {
    clear(areaExtractor(object));
    objectLocations.remove(object);
  }

  operator [](int col) {
    if (columns[col] == null) return nullingColumn;
    return columns[col];
  }

  areaExtractor(object) {
    var points = objectLocations[object];
    if (points != null) return points.fold(null, extractAreaFromPoints);
    return new Rectangle(0,0,0,0);
  }

  extractAreaFromPoints(Rectangle area, Point nextPoint) {
    if (area == null) area = new Rectangle(nextPoint.x, nextPoint.y, 1, 1); //first point

    if (nextPoint.x < area.left) area = new Rectangle(nextPoint.x, area.top, area.right - nextPoint.x, area.height); //new left bound

    if (nextPoint.x + 1 > area.right) area = new Rectangle(area.left, area.top, nextPoint.x + 1 - area.left, area.height); //new right bound

    if (nextPoint.y < area.top ) area = new Rectangle(area.left, nextPoint.y, area.width, area.bottom - nextPoint.y); //new top bound

    if (nextPoint.y + 1 > area.bottom) area = new Rectangle(area.left, area.top, area.width, nextPoint.y + 1 - area.top); //new bottom bound

    return area;
  }

  add(Object object, {Rectangle at}) {
    if (at == null) return addCollisionFree(object, new Rectangle(0,0,1,1));
    return moveColliding(object, at)..add(object);
  }

  moveColliding(Object object, Rectangle nextArea) {
    remove(object);
    Set collidingObjects = findCollidingObjects(nextArea);
    collidingObjects.remove(object);


    Set collisions = new Set.from(collidingObjects);

    collidingObjects.forEach((collidingObject) {
      var currentArea = areaExtractor(collidingObject);
      Rectangle collisionArea = new Rectangle(
      nextArea.right,
      currentArea.top,
      currentArea.width,
      currentArea.height
    );
      collisions.addAll(moveColliding(collidingObject, collisionArea));
    });

    addObjectAtArea(object, nextArea);
    return collisions;
  }

  findCollidingObjects(Rectangle collisionArea) {
    Set collidingObjects = new Set();
    for (var rowNumber = collisionArea.top ; rowNumber <= collisionArea.top + collisionArea.height - 1 ; rowNumber++) {
      for (var columnNumber = collisionArea.left ; columnNumber < collisionArea.left + collisionArea.width ; columnNumber++) {
        var collision = this[columnNumber][rowNumber];
        if (collision != null) collidingObjects.add(collision);
      }
    }
    return collidingObjects;
  }

  addCollisionFree(Object object, Rectangle preferred) {
    if (isFree(preferred)) {
      return addObjectAtArea(object, preferred);
    } else {
      for (var currentRow = 0 ; currentRow <= maxRow ; currentRow++) {
        var maxColumn = columns[currentRow].keys.reduce(max);
        for (var currentColumn = 0 ; currentColumn <= maxColumn + 1; currentColumn++) {
          Rectangle rectangle = new Rectangle(currentColumn, currentRow, preferred.width, preferred.height);
          if (isFree(rectangle)) return addObjectAtArea(object, rectangle);
        }
        //TODO case everything is full
      }
    }
  }

  isFree(Rectangle rectangle) {
    for (var column = rectangle.left ; column < rectangle.left + rectangle.width ; column++) {
      for (var row = rectangle.top ; row < rectangle.top + rectangle.bottom ; row++) {
        if (this[column][row] != null) return false;
      }
    }
    return true;
  }

}

@Injectable()
class MinRows {
  final int rows;

  MinRows(): rows = 2;
  MinRows.value(this.rows);
}

@Injectable()
class NullingColumn {
  operator [](_) {
    return null;
  }
}
