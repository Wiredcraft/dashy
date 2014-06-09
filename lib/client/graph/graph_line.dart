library graph_line;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:dashy/client/graph/graph.dart';

@Decorator(
    selector: '[graph]',
    map: const {
        'graph-model' : '=>setGraph'
    }
)
class GraphLine {
  Element element;
  Scope scope;

  GraphLine(this.element, this.scope);

  set setGraph(graph) {
    scope.context['graph'] = graph;
    element.classes.add('line');
    scope.watch('graph.d', (_new, _) {
      if(_new != null) {
        element.attributes['d']= _new;
      }
    });
  }
}
