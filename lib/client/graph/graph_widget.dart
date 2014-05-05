library graph_widget;

import 'package:angular/angular.dart';

@Component(
  selector: 'graph',
  publishAs: 'comp',
  templateUrl: 'packages/dashy/client/graph/graph.html',
  map: const {
    'model' : '=>model'
  },
  useShadowDom: false
)
class GraphWidget {
  dynamic model;

  GraphWidget();
}
