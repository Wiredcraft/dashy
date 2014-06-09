library grid;

import 'dart:js';
import 'package:angular/angular.dart';
import 'package:dashy/client/widget_factory/widget_factory.dart';
import 'package:dashy/client/widget/widget.dart';

@Injectable()
class Grid {
  int _rows = 2;
  get rows => _rows;

  JsObject grid;

  regenerateGrid({Iterable<WidgetConfiguration> items, int rows}) {
    if (rows != null) _rows = rows;

    var widgetPositions = items.map(newWidgetPosition);

    _renewGrid(widgetPositions);
  }

  _renewGrid(widgetPositions) {
    grid = new JsObject(context['GridList'], [new JsArray.from(widgetPositions), new JsObject.jsify({
        'rows': _rows
    })]);
  }


  newWidgetPosition(WidgetConfiguration widgetConfiguration) =>
  new JsObject.jsify({
      'x': widgetConfiguration.x,
      'y': widgetConfiguration.y,
      'w': widgetConfiguration.w,
      'h': widgetConfiguration.h,
      'id':widgetConfiguration.id
  });

}
