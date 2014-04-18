library test_module;

import '_specs.dart';
import 'dart:async';
import 'package:dashy/client/app/app.dart';
import 'package:dashy/client/app/app_component.dart';
import 'package:dashy/client/gauge/gauge.dart';
import 'package:dashy/client/gauge/gauge_component.dart';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/widget/widget_component.dart';
import 'package:dashy/client/widget_factory.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';
import 'package:dashy/client/message_router/message_router.dart';
import 'package:dashy/client/websocket_wrapper/websocket_wrapper.dart';

const configYaml =
'''widgets:
 - some-widget-id:
     attributes:
       some-attribute:
         some-datasource: some-attribute-on-datasource
     type: Gauge
''';

class MockDashyModule extends Module {
  MockDashyModule() {
    value(TimedEventBroadcaster, new TimedEventBroadcaster(new StreamController.broadcast()));

    factory(WidgetFactory,(i) {
      return new WidgetFactory(
        i.get(TimedEventBroadcaster),
        new StreamController.broadcast(),
        configYaml
      );
    });

    type(App);
    type(AppComponent);
    type(GaugeComponent);
    type(WidgetComponent);
    type(MessageRouter);
    factory(WebSocketWrapper, (i) => new WebSocketWrapper(i.get
    (MessageRouter), new StreamController.broadcast()));
  }
}

main(){}
