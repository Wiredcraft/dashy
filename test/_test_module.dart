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
import 'package:dashy/client/widget/configuration.dart';


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
    bind(WidgetFactory);
    bind(App);
    bind(AppComponent);
    bind(TimeFromNow);
    bind(MarkdownWidget);
    bind(GaugeComponent);
    bind(WidgetComponent);
    bind(MessageRouter);
    bind(WebSocketWrapper);
    bind(Grid);
    bind(ConfigurationWidget);
  }
}

main(){}
