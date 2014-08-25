library widget_component;

import 'dart:html';
import 'dart:js';
import 'package:angular/angular.dart';
import 'package:dashy/client/grid/grid.dart';
import 'package:dashy/client/grid/drag_n_drop.dart';
import 'package:dashy/client/gauge/gauge.dart';
import 'package:dashy/client/graph/graph.dart';
import 'package:dashy/client/markdown/markdown.dart';
import 'package:dashy/client/widget/widget.dart';


const WIDTH_OFFSET=40;
const HEIGHT_OFFSET=32;

/**
 * The [WidgetComponent] is the glue between the view template and the model.
 * It is responsible for rendering the location and correct type of widget.
 */
@Component(
    selector: 'widget',
    templateUrl: 'packages/dashy/client/widget/widget.html',
    publishAs: 'widg',
    map: const {
        'app-height': '=>setAppHeight',
        'widget-model' : '=>setWidget'
    },
    useShadowDom: false
)
class WidgetComponent {
  Element element;
  Scope scope;
  Widget widget;
  bool displaying = true;
  DndGrid dndGrid;

  Grid grid;

  WidgetComponent(this.element, this.scope, this.grid, this.dndGrid);

  int get cellSize  => (scope.context['appHeight'] / grid.maxRow).floor();

  set setAppHeight(int _appHeight) {
    scope.context['appHeight'] = _appHeight;
  }

  set setWidget(Widget _widget) {
    widget = _widget;
    scope.context['widget'] = _widget;
    grid.add(widget, at: new Rectangle(widget.x, widget.y, widget.w, widget.h));

    dndGrid.registerWidget(element, widget);

    scope
      ..watch('widget.x', (newX, _) {
        _newXLocation(newX);
      })
      ..watch('widget.y', (newY, _) {
        _newYLocation(newY);
      })
      ..watch('widget.w', (newW, _) {
        _newBodyWidth(newW);
      })
      ..watch('widget.h', (newH, _) {
        _newBodyHeight(newH);
      })
      ..watch('appHeight', (newHeight, _) {
        _newBodyWidth(widget.w);
        _newBodyHeight(widget.h);
        _newXLocation(widget.x);
        _newYLocation(widget.y);
    });
  }

  _newYLocation(newY) {
    element.style.top = '${_cssDimension(newY)}px';
  }

  _newXLocation(newX) {
    element.style.left = '${_cssDimension(newX)}px';
  }

  _newBodyHeight(int gridCount) {
    var newHeight = _cssDimension(gridCount);
    if (newHeight > 0) {
      scope.context['bodyHeight'] = newHeight;
      element.style.height = '${newHeight}px';
    } else {
      scope.context['bodyHeight'] = 0;
      element.style.height  = '0px';
    }
  }

  _newBodyWidth(int gridCount) {
    var newWidth = _cssDimension(gridCount);
    if (newWidth > 0) {
      scope.context['bodyWidth'] = newWidth;
      element.style.width = '${newWidth}px';
    } else {
      scope.context['bodyWidth'] = 0;
      element.style.width = '0px';
    }
  }

  int _cssDimension(int gridCount) => gridCount * cellSize;


  get isGauge => widget.model.isNotEmpty ? widget.model.first is Gauge : false;
  get isGraph => widget.model.isNotEmpty ? widget.model.first is Graph : false;
  get isMarkdown => widget.model.isNotEmpty ? widget.model.first is Markdown : false;

}
