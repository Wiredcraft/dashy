library widget_component;

import 'dart:html';
import 'dart:js';
import 'package:angular/angular.dart';
import 'package:dashy/client/grid/grid.dart';
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
        'widget' : '=>setWidget',
        'app-height': '=>setAppHeight'
    },
    useShadowDom: false
)
class WidgetComponent {
  Element element;
  Scope scope;
  String get id => widget.id;
  Widget widget;
  bool displaying = true;
  var appHeight = 0;

  Grid grid;

  int get cellSize  => (appHeight / grid.rows).floor();

  set setAppHeight(_appHeight) {
    appHeight = _appHeight;
    scope.context['cellSize'] = cellSize;
  }

  WidgetComponent(this.element, this.scope, this.grid);

  set setWidget(Widget _widget) {
    widget = _widget;
    scope.context['widget'] = widget;

    scope.watch('cellSize', (_, __) {
      element.style.left = '${widget.x * cellSize}px';
      element.style.top = '${widget.y * cellSize}px';
      element.style.width = '${widget.w * cellSize}px';
      element.style.height = '${widget.h * cellSize}px';
    });

    scope
    ..watch('widget.x', (newX, _) {
      element.style.left = '${newX * cellSize}px';
    })

    ..watch('widget.y', (newY, _) {
      element.style.top = '${newY * cellSize}px';
    })

    ..watch('widget.w', (newW, _) {
      element.style.width = '${newW * cellSize}px';
    })

    ..watch('widget.h', (newH, _) {
      element.style.height = '${newH * cellSize}px';
    });

  }

  get childWidth => element.clientWidth - WIDTH_OFFSET;
  get childHeight => element.clientHeight - HEIGHT_OFFSET;

  get isGauge => widget.model.isNotEmpty ? widget.model.first is Gauge : false;
  get isGraph => widget.model.isNotEmpty ? widget.model.first is Graph : false;
  get isMarkdown => widget.model.isNotEmpty ? widget.model.first is Markdown : false;

}
