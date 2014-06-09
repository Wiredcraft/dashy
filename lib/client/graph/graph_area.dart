library graph_area;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:dashy/client/graph/graph.dart';


@Decorator(
    selector: '[graph-area]',
    map: const {
        'graph-model' : '=>setGraph'
    }
)
class GraphArea {
  Element element;
  Scope scope;
  Graph graph;

  GraphArea(this.element, this.scope);

  set setGraph(_graph) {
    graph = _graph;
    scope.context['graph'] = graph;
    element.classes.add('area');
    scope.watch('graph.areaD', (_new, _) {
      if(_new != null) {
        element.attributes['d'] = _new;
      }
    });
  }
}
