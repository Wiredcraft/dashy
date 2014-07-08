library app;

import 'dart:async';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/websocket_wrapper/websocket_wrapper.dart';
import 'package:angular/angular.dart';

/**
 * The [App] model is responsible for maintaining a collection of [Widget]s.
 */
@Injectable()
class App {
  Set<Widget> widgets = new Set<Widget>();
  Set<Widget> fillerWidgets = new Set<Widget>();

  WebSocketWrapper webSocketWrapper;

  App(this.webSocketWrapper);

}
