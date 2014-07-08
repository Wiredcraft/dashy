library addition_factory;

import 'dart:math';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/app/app.dart';
import 'package:dashy/client/grid/grid.dart';
import 'package:dashy/client/addition/addition_component.dart';
import 'package:angular/angular.dart';


/*
The [AdditionFactory] handles requests for new filler/addition widgets. The grid gets scanned for
open spots, for each open spot such a widget gets added to the app. The previous set get stored and removed on each request.
 */
@Injectable()
class FillerWidgetFactory {
  Grid grid;

  FillerWidgetFactory(this.grid);

  call() {
    Set<Widget> newFillerWidgets = new Set();
    List<Rectangle> locations = getFreeSpaces();
    locations.forEach((location) {
      newFillerWidgets.add(new Widget([], 'filler', location.left, location.top, location.width, location.height, [], ''));
    });

    return newFillerWidgets;
  }

  getFreeSpaces() {
    Set<Rectangle> freeSpaces = new Set();

    List<int> takenRowNumbers = grid.rows.keys;

    var maxColumns = takenRowNumbers.map((rowNumber) {
      if (grid.rows[rowNumber].keys.isNotEmpty) return grid.rows[rowNumber].keys.reduce(max);
      return 0;
    });

    var maxCol = 1;

    if (maxColumns.isNotEmpty) maxCol = maxColumns.reduce(max) + 1;

    for (int rowNumber = 0; rowNumber < grid.maxRow ; rowNumber++) {
      for (int colNumber = 0 ; colNumber <= maxCol; colNumber++) {
        if (grid.rows[rowNumber] == null) grid.rows[rowNumber] = new Map();
        if (!grid.rows[rowNumber].keys.contains(colNumber)) {
          freeSpaces.add(new Rectangle(colNumber, rowNumber, 1, 1));
        }
      }
    }
    return freeSpaces;
  }
}
