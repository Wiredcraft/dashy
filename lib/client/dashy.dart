library dashy.module;

import 'dart:async';
import 'package:angular/angular.dart';
import 'package:dashy/client/gauge/gauge_component.dart';
import 'package:dashy/client/gauge/gauge_arc.dart';
import 'package:dashy/client/graph/graph_line.dart';
import 'package:dashy/client/graph/graph_widget.dart';
import 'package:dashy/client/widget_factory/widget_factory.dart';
import 'package:dashy/client/widget/widget_component.dart';
import 'package:dashy/client/app/app_component.dart';
import 'package:dashy/client/app/app.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';
import 'package:dashy/client/message_router/message_router.dart';
import 'package:dashy/client/websocket_wrapper/websocket_wrapper.dart';
import 'package:dashy/client/grid/grid.dart';

const configYaml =
'''widgets:
- some-widget-id:
    attributes:
     value:
       CPU: value
    type: Gauge
    layout:
      x: 0
      y: 0
      w: 1
      h: 1
- graph-widget-id:
    attributes:
     value:
       CPU: value
    type: Graph
    settings:
    duration:
      seconds: 10
    layout:
      x: 1
      y: 1
      w: 2
      h: 1
''';

class DashyModule extends Module {
  DashyModule() {
    bind(TimedEventBroadcaster);
    bind(Grid);
    bind(WidgetFactory, toFactory: (i) {
      return new WidgetFactory(
          i.get(TimedEventBroadcaster),
          i.get(Grid),
          configYaml
      );
    });
    bind(App);
    bind(AppComponent);
    bind(GaugeComponent);
    bind(GaugeArc);
    bind(GraphLine);
    bind(GraphWidget);
    bind(WidgetComponent);
    bind(MessageRouter);
    bind(WebSocketWrapper, toFactory: (i) => new WebSocketWrapper(i.get
    (MessageRouter), new StreamController.broadcast()));
  }
}



