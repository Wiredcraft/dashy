library widgets_component;

import 'package:angular/angular.dart';
import '../../model/widget.dart';


@NgComponent(
    selector: 'widgets',
    publishAs: 'cmpt',
    templateUrl: 'packages/dashy/client/component/widgets/widgets.html',
    cssUrl: 'packages/dashy/client/component/widgets/widgets.css'
)
class WidgetsComponent {
  List gauges = [new Gauge()];
  
  
  WidgetsComponent() {
    
  }
}