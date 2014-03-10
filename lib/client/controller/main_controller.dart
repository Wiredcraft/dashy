library main_controller;

import 'package:angular/angular.dart';
import 'package:dashy/client/model/widget.dart';

@NgController(
  selector: '[main-controller]',
  publishAs: 'mainctrl'
)
class MainController {
  List<Widget> widgets;
  
  MainController() {
  }
  
}
