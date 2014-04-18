library app_component;

import 'package:angular/angular.dart';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/app/app.dart';

@Component(
  selector: 'app',
  templateUrl: 'packages/dashy/client/app/app.html',
  publishAs: 'app'
)
class AppComponent {
  App model;

  AppComponent(this.model);
}
