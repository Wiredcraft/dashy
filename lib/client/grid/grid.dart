library grid;

import 'dart:js';
import 'dart:async';
import 'package:angular/angular.dart';
import 'package:dashy/client/widget_factory/widget_factory.dart';
import 'package:dashy/client/widget/widget.dart';

@Injectable()
class Grid {
  int _rows = 2;
  get rows => _rows;
  Map widgetInGrid = new Map();

  JsObject grid;

  regenerateGrid({Iterable<WidgetConfiguration> items, int rows}) {
    if (rows != null) _rows = rows;

    if (items != null) {
      var widgetIds = new List();
      items.forEach((item) => widgetIds.add(item.id));
      var positioningObjects = items.map(widgetPositioningObjectExtraction);

      grid = new JsObject(
      context['GridList'],
      [new JsArray.from(positioningObjects),
       new JsObject.jsify({'rows': _rows })]);
      widgetIds.forEach((id) {
        widgetInGrid[id] = grid.callMethod('_getItemByAttribute', ['id', id]);
      });
    }
  }

  operator [](id) => widgetInGrid[id];


  widgetPositioningObjectExtraction(WidgetConfiguration widgetConfiguration) =>
  new JsObject.jsify({
      'x': widgetConfiguration.x,
      'y': widgetConfiguration.y,
      'w': widgetConfiguration.w,
      'h': widgetConfiguration.h,
      'id':widgetConfiguration.id
  });

}
