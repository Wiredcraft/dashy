library widget_component;

import 'dart:html';
import 'dart:math';
import 'package:angular/angular.dart';
import 'package:dashy/client/grid/grid.dart';
import 'package:dashy/client/gauge/gauge.dart';
import 'package:dashy/client/graph/graph.dart';

/**
 * The [WidgetComponent] is the glue between the view template and the model.
 * It is responsible for rendering the location and correct type of widget.
 */
@Component(
    selector: 'widget',
    templateUrl: 'packages/dashy/client/widget/widget.html',
    publishAs: 'widg',
    map: const {
        'widget' : '=>widget',
        'app-height': '=>appHeight'
    },
    useShadowDom: false
)
class WidgetComponent {
  Element element;
  Scope scope;
  var model;
  var x;
  var y;
  var w;
  var h;

  Grid grid;
  var _appHeight = 0;

  int get cellSize  => (_appHeight / grid.rows).floor();

  set appHeight(appHeight) {
    scope.watch('cellSize', (_,__) {
      element.style.left = '${x * cellSize}px';
      element.style.top = '${y * cellSize}px';
      element.style.width = '${w * cellSize}px';
      element.style.height = '${h * cellSize}px';
    }, canChangeModel: false);

    _appHeight = appHeight;
  }

  WidgetComponent(this.element, this.scope, this.grid);

  set widget(widget) {
    scope
    ..watch('x', (newX, _) {
      x=newX;
      element.style.left = '${newX * cellSize}px';
    }, context: widget, canChangeModel: false)

    ..watch('y', (newY, _) {
      y = newY;
      element.style.top = '${newY * cellSize}px';
    }, context: widget, canChangeModel: false)

    ..watch('w', (newW, _) {
      w = newW;
      element.style.width = '${newW * cellSize}px';
    }, context: widget, canChangeModel: false)

    ..watch('h', (newH, _) {
      h = newH;
      element.style.height = '${newH * cellSize}px';
    }, context: widget, canChangeModel: false)

    ..watch('model', (newModel , _) {
      model = newModel;
    }, context: widget, canChangeModel: false);

  }

  get isGauge => model.runtimeType == Gauge;
  get isGraph => model.runtimeType == Graph;
}
