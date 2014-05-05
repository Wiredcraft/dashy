library dashy.module;

import 'dart:async';
import 'package:angular/angular.dart';
import 'package:dashy/client/gauge/gauge_component.dart';
import 'package:dashy/client/graph/graph_line.dart';
import 'package:dashy/client/graph/graph_widget.dart';
import 'package:dashy/client/widget_factory/widget_factory.dart';
import 'package:dashy/client/widget/widget_component.dart';
import 'package:dashy/client/app/app_component.dart';
import 'package:dashy/client/app/app.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';
import 'package:dashy/client/message_router/message_router.dart';
import 'package:dashy/client/websocket_wrapper/websocket_wrapper.dart';

const configYaml =
'''widgets:
- some-widget-id:
     attributes:
       value:
         CPU: value
     type: Gauge
- graph-widget-id:
     attributes:
       value:
         CPU: value
     type: Graph
''';

class DashyModule extends Module {
  DashyModule() {
    bind(TimedEventBroadcaster);
    bind(WidgetFactory, toFactory: (i) {
      return new WidgetFactory(
          i.get(TimedEventBroadcaster),
          new StreamController.broadcast(),
          configYaml
      );
    });
    bind(App);
    bind(AppComponent);
    bind(GaugeComponent);
    bind(GraphLine);
    bind(GraphWidget);
    bind(WidgetComponent);
    bind(MessageRouter);
    bind(WebSocketWrapper, toFactory: (i) => new WebSocketWrapper(i.get
    (MessageRouter), new StreamController.broadcast()));
  }
}



