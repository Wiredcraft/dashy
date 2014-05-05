library widget_component;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:dashy/client/gauge/gauge.dart';
import 'package:dashy/client/graph/graph.dart';

/**
 * The [WidgetComponent] is the glue between the view template and the model.
 * It is responsible for rendering the correct type of widget.
 */
@Component(
    selector: 'widget',
    templateUrl: 'packages/dashy/client/widget/widget.html',
    publishAs: 'widg',
    map: const {
        'model' : '=>model'
    },
    useShadowDom: false
)
class WidgetComponent {
  Element element;
  var model;

  WidgetComponent(this.element);

  get isGauge => model.runtimeType == Gauge;
  get isGraph => model.runtimeType == Graph;
}
