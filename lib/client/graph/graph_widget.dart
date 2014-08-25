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
  Element element;
  Scope scope;

  String get viewBox => '2 0 ${scope.context['width']} ${scope.context['height']}';

  GraphWidget(this.element, this.scope);

  set setHeight(height) {
    scope.context['height'] = height;
    scope.context['graph'].rescaleRange();
  }

  set setWidth(width) {
    scope.context['width'] = width;
    scope.context['graph'].rescaleRange();
  }

  set setModel(_graph) {
    scope.context['graph'] = _graph;
  }
}
