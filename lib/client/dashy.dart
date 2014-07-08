library dashy.module;

import 'package:angular/angular.dart';
import 'package:angular/animate/module.dart';
import 'package:dashy/client/time_from_now/time_from_now.dart';
import 'package:dashy/client/gauge/gauge_component.dart';
import 'package:dashy/client/gauge/gauge_arc.dart';
import 'package:dashy/client/graph/graph_line.dart';
import 'package:dashy/client/graph/graph_area.dart';
import 'package:dashy/client/graph/graph_widget.dart';
import 'package:dashy/client/widget_factory/widget_factory.dart';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/widget/widget_component.dart';
import 'package:dashy/client/markdown/markdown_widget.dart';
import 'package:dashy/client/app/app_component.dart';
import 'package:dashy/client/app/app.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';
import 'package:dashy/client/message_router/message_router.dart';
import 'package:dashy/client/websocket_wrapper/websocket_wrapper.dart';
import 'package:dashy/client/grid/grid.dart';
import 'package:dashy/client/grid/drag_n_drop.dart';
import 'package:dashy/client/addition/addition_component.dart';
import 'package:dashy/client/addition/addition_factory.dart';
import 'package:dashy/client/widget/configuration.dart';



//'''widgets:
//- gauge:
//    attributes:
//       - CPU
//    type: Gauge
//    layout:
//      x: 0
//      y: 0
//      w: 1
//      h: 1
//- graph:
//    attributes:
//      - CPU
//    type: Graph
//    settings:
//      duration:
//        seconds: 10
//    layout:
//      x: 1
//      y: 1
//      w: 2
//      h: 1''';


class DashyModule extends Module {
  DashyModule() {
//    install(new AnimationModule());
    install(new GridModule());

    bind(TimedEventBroadcaster);
    bind(Grid);
    bind(WidgetFactory);
    bind(App);
    bind(TimeFromNow);
    bind(AppComponent);
    bind(GaugeComponent);
    bind(GaugeArc);
    bind(GraphLine);
    bind(GraphArea);
    bind(GraphWidget);
    bind(MarkdownWidget);
    bind(WidgetComponent);
    bind(ConfigurationWidget);
    bind(MessageRouter);
    bind(WebSocketWrapper);
    bind(DndGrid);
    bind(FillerWidget);
    bind(FillerWidgetFactory);
//    bind(ScopeDigestTTL, toValue: new ScopeDigestTTL.value(100));
  }
}
