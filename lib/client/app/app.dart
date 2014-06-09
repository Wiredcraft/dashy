library app;

import 'dart:async';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/widget_factory/widget_factory.dart';
import 'package:dashy/client/websocket_wrapper/websocket_wrapper.dart';
import 'package:angular/angular.dart';

/**
 * The [App] model is responsible for maintaining a collection of [Widget]s.
 */
@Injectable()
class App {
  Set<Widget> widgets = new Set<Widget>();
  StreamSubscription _sub;
  WebSocketWrapper webSocketWrapper;

  App(WidgetFactory widgetFactory, this.webSocketWrapper) {
    widgets.addAll(widgetFactory.widgetsFromYaml(configYaml));
  }
}


const configYaml =
'''widgets:
- gauge:
    datasources:
       - CPU
    type: Gauge
    layout:
      x: 0
      y: 0
      w: 1
      h: 1
- graph:
    datasources:
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
    datasources:
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
