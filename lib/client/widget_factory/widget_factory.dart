library dashy.widget_factory;


import 'dart:html';
import 'dart:async';
import 'dart:math';
import 'package:yaml/yaml.dart';
import 'package:angular/angular.dart';
import 'package:dashy/client/gauge/gauge.dart';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';

part 'widget_configuration.dart';

/**
 * The [WidgetFactory] creates widgets based on configuration. It
 * converts a configuration yaml string to new widgets which need the
 * [TimedEventBroadcaster] to subscribe to the datasources they
 * are interested in. Finally it uses the newWidgets [StreamController] to
 * add new widgets to the [App]s' model
 */
@Injectable()
class WidgetFactory {
  TimedEventBroadcaster timedEventBroadcaster;
  StreamController newWidgets;
  String yaml;

  WidgetFactory(this.timedEventBroadcaster, this.newWidgets, String this.yaml);

  init() {
    widgetsFromYaml(yaml);
  }

  widgetsFromYaml(yaml) {
    var decoded = loadYaml(yaml);
    decoded['widgets'].forEach(_createWidget);
  }

  _createWidget(widgetConfigurationMap) {
    var subscribeToStreams = new Set();

    WidgetConfiguration widgetConfiguration =
    new WidgetConfiguration.fromMap(widgetConfigurationMap);

    widgetConfiguration.dataSources
      .forEach((dataSourceString) {
        subscribeToStreams.
        add(timedEventBroadcaster.registerDataSource(dataSourceString).stream);
    });

    if (widgetConfiguration.type == 'Gauge') {
      newWidgets.add(new Widget(new Gauge(subscribeToStreams)));
    }
  }

}



