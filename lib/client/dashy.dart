library dashy_module;

import 'package:angular/angular.dart';
import 'package:dashy/client/component/widgets/widgets_component.dart';


class DashyModule extends Module {
  DashyModule() {
    type(WidgetsComponent);
  }
}