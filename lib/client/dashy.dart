library dashy.module;

import 'dart:async';
import 'package:angular/angular.dart';
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

const configYaml =
'''widgets:
- gauge:
    attributes:
       - CPU
    type: Gauge
    layout:
      x: 0
      y: 0
      w: 1
      h: 1
- graph:
    attributes:
      - CPU
    type: Graph
    settings:
      duration:
        seconds: 10
    layout:
      x: 1
      y: 1
      w: 2
      h: 1
- github feed:
    attributes:
       - git
       - CPU
    type: Markdown
    settings:
      markdown: |
        <img ng-if="comp.model['image'] != null" ng-src="{{comp.model['image']}}" width="100" height="100"/>

        <span ng-if="comp.model['user'] != null"> {{ comp.model['user'] }} </span>

        <p ng-if="comp.model['title'] != null">Latest commit: {{ comp.model['title'] }} </p>

        <timefromnow for-date="comp.model['some-time-in-the-future']"></timefromnow>

        <br /><br />

        <timefromnow for-date="comp.model['some-time-in-the-past']"></timefromnow>
    layout:
      x: 1
      y: 0
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
    bind(Widget);
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
    bind(MessageRouter);
    bind(ScopeDigestTTL, toValue: new ScopeDigestTTL.value(30));
    bind(WebSocketWrapper, toFactory: (i) => new WebSocketWrapper(i.get
    (MessageRouter), new StreamController.broadcast()));
  }
}



