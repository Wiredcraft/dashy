library widget_component;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/gauge/gauge.dart';

@Component(
    selector: 'widget',
    templateUrl: 'packages/dashy/client/widget/widget.html',
    publishAs: 'widg',
    map: const {
        'model' : '=>setModel'
    }
)
class WidgetComponent {
  Element element;
  var model;

  WidgetComponent(this.element);

  set setModel(dynamic _model) {
    model = _model;
  }

  isGauge() => model.runtimeType == Gauge;
}
