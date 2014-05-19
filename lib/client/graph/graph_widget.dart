library graph_widget;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:dashy/client/graph/graph.dart';

const WIDTH_OFFSET=40;
const HEIGHT_OFFSET=32;

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
  Graph model;
  Element element;
  Scope scope;

  int width;

  int height = 0;

  set setHeight(_height) => height = _height - HEIGHT_OFFSET;

  set setWidth(_width) => width = _width - WIDTH_OFFSET;

  String get viewBox => '2 0 ${width-WIDTH_OFFSET} ${height-HEIGHT_OFFSET}';

  GraphWidget(this.element, this.scope);

  set setModel(_model) {
    model = _model;
    scope..watch('width', (_,__) {
      model.width = width;
      model.rescaleRange();
    }, context: this);
    scope..watch('height', (_,__) {
      model.height = height;
      model.rescaleRange();
    }, context: this);

  }
}
