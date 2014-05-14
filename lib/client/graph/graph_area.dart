library graph_area;

import 'dart:html';
import 'package:angular/angular.dart';


@Decorator(
    selector: '[graph-area]',
    map: const {
        'graph-model' : '=>graph'
    }
)
class GraphArea {
  Element element;
  Scope scope;

  GraphArea(this.element, this.scope);

  set graph(graph) {
    element.classes.add('area');
    scope.watch('areaD', (_new, _) {
      if(_new != null) {
        element.attributes['d'] = _new;
      }
    }, context: graph, canChangeModel: false);
  }
}
