library test_module;

import '_specs.dart';
import 'dart:async';
import 'package:dashy/client/app/app.dart';
import 'package:dashy/client/app/app_component.dart';
import 'package:dashy/client/time_from_now/time_from_now.dart';
import 'package:dashy/client/gauge/gauge_component.dart';
import 'package:dashy/client/markdown/markdown_widget.dart';
import 'package:dashy/client/widget/widget_component.dart';
import 'package:dashy/client/widget_factory/widget_factory.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';
import 'package:dashy/client/message_router/message_router.dart';
import 'package:dashy/client/websocket_wrapper/websocket_wrapper.dart';
import 'package:dashy/client/grid/grid.dart';

const configYaml =
'''widgets:
 - some-widget-id:
     attributes:
       - some-datasource
     type: Gauge
''';

class MockDashyModule extends Module {
  MockDashyModule() {
    bind(TimedEventBroadcaster);
    bind(WidgetFactory, toFactory: (i) {
      return new WidgetFactory(
        i.get(TimedEventBroadcaster),
        i.get(Grid),
        configYaml
      );
    });
    bind(App);
    bind(AppComponent);
    bind(TimeFrom);
    bind(MarkdownWidget);
    bind(GaugeComponent);
    bind(WidgetComponent);
    bind(MessageRouter);
    bind(WebSocketWrapper, toFactory: (i) => new WebSocketWrapper(i.get
    (MessageRouter), new StreamController.broadcast()));
    bind(Grid);
  }
}

main(){}
