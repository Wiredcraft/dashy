library app_component;

import 'dart:html';
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
  var clientHeight;
  App model;
  Scope scope;

  AppComponent(Element element, this.scope, this.model) {
    clientHeight = window.document.documentElement.clientHeight;
    window.onResize.listen((_) => clientHeight = window.document.documentElement.clientHeight);
  }
}
