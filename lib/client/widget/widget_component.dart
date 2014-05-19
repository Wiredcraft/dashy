library widget_component;

import 'dart:html';
import 'dart:math';
import 'dart:js';
import 'package:angular/angular.dart';
import 'package:dashy/client/grid/grid.dart';
import 'package:dashy/client/gauge/gauge.dart';
import 'package:dashy/client/graph/graph.dart';
import 'package:dashy/client/markdown/markdown.dart';
import 'package:dashy/client/widget/widget.dart';

/**
 * The [WidgetComponent] is the glue between the view template and the model.
 * It is responsible for rendering the location and correct type of widget.
 */
@Component(
    selector: 'widget',
    templateUrl: 'packages/dashy/client/widget/widget.html',
    publishAs: 'widg',
    map: const {
        'widget' : '=>setWidget',
        'app-height': '=>appHeight'
    },
    useShadowDom: false
)
class WidgetComponent {
  Element element;
  Scope scope;
  var model;
  String get id => widget.id;
  Widget widget;
  var x;
  var y;
  var w;
  var h;


  Grid grid;
  var _appHeight = 0;

  int get cellSize  => (_appHeight / grid.rows).floor();

  set appHeight(appHeight) {
    _appHeight = appHeight;
  }

  WidgetComponent(this.element, this.scope, this.grid) {
    scope.watch('cellSize', (_, __) {
      if (x != null) element.style.left = '${x * cellSize}px';
      if (y != null) element.style.top = '${y * cellSize}px';
      if (w != null) element.style.width = '${w * cellSize}px';
      if (h != null) element.style.height = '${h * cellSize}px';
    }, context:this);

    element.onDragStart.listen(dragStart);
    element.onDragEnd.listen(dragEnd);
    element.onDrop.listen(drop);
    element.onDragOver.listen(dragOver);

  }

  dragStart(MouseEvent event) {
    element.classes.add('moving');
    event.dataTransfer.effectAllowed = 'move';
  }

  dragOver(event) {
    event.preventDefault();
    event.dataTransfer.dropEffect = 'move';
  }

  dragEnd(MouseEvent event) {
    element.classes.remove('moving');
    grid.grid.callMethod('moveItemToPosition', [grid.widgetInGrid[widget.id], new JsArray.from([4,1])]);
  }

  drop(MouseEvent event) {
    event.stopPropagation();
  }

  set setWidget(Widget _widget) {
    widget = _widget;
    scope
    ..watch('x', (newX, _) {
      x = newX();
      element.style.left = '${x * cellSize}px';
    }, context: widget, canChangeModel: true)

    ..watch('y', (newY, _) {
      y = newY();
      element.style.top = '${y * cellSize}px';
    }, context: widget, canChangeModel: true)

    ..watch('w', (newW, _) {
      w = newW();
      element.style.width = '${w * cellSize}px';
    }, context: widget, canChangeModel: true)

    ..watch('h', (newH, _) {
      h = newH();
      element.style.height = '${h * cellSize}px';
    }, context: widget, canChangeModel: true)

    ..watch('model', (newModel , _) {
      model = newModel;
    }, context: widget, canChangeModel: true);

  }

  get isGauge => model.first is Gauge;
  get isGraph => model.first is Graph;
  get isMarkdown => model.first is Markdown;
}
