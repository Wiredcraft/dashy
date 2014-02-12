library widgets_component;

import 'package:angular/angular.dart';

@NgComponent(
    selector: 'widgets',
    templateUrl: 'packages/dashy/client/component/widgets/widgets_component.html',
    cssUrl:  'packages/dashy/client/component/widgets/widgets_component.css',
    publishAs: 'cmp')
class WidgetsComponent {
  WidgetsComponent() {
    print('WidgetsComponent constructed');
  }
}
