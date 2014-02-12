library main_controller;

import 'package:angular/angular.dart';
import 'package:dashy/client/backend.dart';
import 'package:dashy/client/model/widget.dart';

@NgController(
  selector: '[main-controller]',
  publishAs: 'mainctrl'
)
class MainController {
  WidgetsBackend _widgetsBackend;
  List<Widget> widgets;
  
  MainController(this._widgetsBackend) {
    _widgetsBackend.getWidgets(this);
  }
  
}
