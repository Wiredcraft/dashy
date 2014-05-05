library graph_line;

import 'dart:html';
import 'package:angular/angular.dart';


@Decorator(
    selector: '[graph]',
    map: const {
        'graph-model' : '=>graph'
    }
)
class GraphLine {
  Element element;
  Scope scope;

  GraphLine(this.element, this.scope);

  set graph(graph) {
    element.classes.add('line');
    scope.watch('d', (_new, _) {
      if(_new != null) {
        element.attributes['d']= _new;
      }
    }, context: graph, canChangeModel: false);
  }
}
