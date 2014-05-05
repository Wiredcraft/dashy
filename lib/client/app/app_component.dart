library app_component;

import 'package:angular/angular.dart';
import 'package:dashy/client/app/app.dart';


/**
 * The [AppComponent] is the glue between the view template and the model.
 */
@Component(
  selector: 'app',
  templateUrl: 'packages/dashy/client/app/app.html',
  publishAs: 'app',
  useShadowDom: false
)
class AppComponent {
  App model;

  AppComponent(this.model);
}
