library app_component;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:dashy/client/app/app.dart';
import 'package:dashy/client/widget_factory/widget_factory.dart';
import 'package:dashy/client/addition/addition_factory.dart';


/**
 * The [AppComponent] is the glue between the view template and the model.
 */
@Component(
  selector: 'app',
  templateUrl: 'packages/dashy/client/app/app.html',
  publishAs: 'appc',
  useShadowDom: false
)
class AppComponent {
  App app;
  Scope scope;
  WidgetFactory widgetFactory;

  AppComponent(this.scope, this.app, this.widgetFactory) {
    var clientHeight = window.document.documentElement.clientHeight;
    scope.context['appHeight'] = clientHeight;

    window.onResize.listen((_) {
      scope.context['appHeight'] = window.document.documentElement.clientHeight;
    });

    app.widgets.addAll(widgetFactory.widgetsFromYamlString(CONFIGYAML));
  }
}

const CONFIGYAML =
'''widgets:
- gauge:
    datasources:
       - system-info
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
