library graph_widget;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:dashy/client/graph/graph.dart';


@Component(
    selector: 'graph',
  publishAs: 'comp',
  templateUrl: 'packages/dashy/client/graph/graph.html',
  map: const {
    'model' : '=>setModel',
    'widget-height' : '=>setHeight',
    'widget-width' : '=>setWidth'
  },
  useShadowDom: false
)
class GraphWidget {
  Graph graph;
  Element element;
  Scope scope;

  int width;

  int height;

  set setHeight(_height) => height = _height;

  set setWidth(_width) => width = _width;

  String get viewBox => '2 0 ${width} ${height}';

  GraphWidget(this.element, this.scope);

  set setModel(_graph) {
    graph = _graph;

    scope.context['width'] = width;
    scope.context['height'] = height;

    scope..watch('width', (_,__) {
      graph.width = width;
      graph.rescaleRange();
    });

    scope..watch('height', (_,__) {
      graph.height = height;
      graph.rescaleRange();
    });

  }
}
