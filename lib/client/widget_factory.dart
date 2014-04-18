library widget_factory;

import 'dart:html';
import 'dart:async';
import 'dart:math';
import 'package:yaml/yaml.dart';
import 'package:angular/angular.dart';
import 'package:dashy/client/gauge/gauge.dart';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';

/**
 * The [WidgetModelFactory] creates widgets based on configuration.
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

class WidgetConfiguration {
  String id;
  Set dataSources = new Set();
  String type;

  WidgetConfiguration.fromMap(map) {
    map.forEach((k, settings) {
      id = k;
      type = settings['type'];

      settings['attributes'].forEach((attributeOnWidget, dataSource) {
        dataSource.forEach((dataSource, attributeOnTimedEvent) {
          dataSources.add(dataSource);
        });
      });

    });
  }
}


