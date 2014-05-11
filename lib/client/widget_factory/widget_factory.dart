library dashy.widget_factory;


import 'dart:async';
import 'package:yaml/yaml.dart';
import 'package:angular/angular.dart';
import 'package:dashy/client/gauge/gauge.dart';
import 'package:dashy/client/graph/graph.dart';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';
import 'package:dashy/client/grid/grid.dart';

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
  StreamController newWidgets = new StreamController.broadcast();
  Grid grid;
  String yaml;

    WidgetFactory(this.timedEventBroadcaster, this.grid, String this.yaml);

  init() {
    widgetsFromYaml(yaml);
  }

  widgetsFromYaml(yaml) {
    var widgetConfigurations,
        widgets,
        decoded = loadYaml(yaml);

    widgetConfigurations = decoded['widgets'].map(createWidgetConfiguration);
    grid.regenerateGrid(items: widgetConfigurations);
    widgetConfigurations.forEach(broadcastWidget);

    return widgets;
  }

  createWidgetConfiguration(widgetConfigurationMap) {

    WidgetConfiguration widgetConfiguration =
    new WidgetConfiguration.fromMap(widgetConfigurationMap);

    return widgetConfiguration;
  }


  broadcastWidget(widgetConfiguration) {
    var subscribeToStreams = new Set();

    widgetConfiguration.dataSources.forEach((dataSourceString) {
      subscribeToStreams.add(timedEventBroadcaster.registerDataSource(dataSourceString).stream);
    });

    switch (widgetConfiguration.type) {
      case 'Gauge' :
        newWidgets.add(new Widget(
            new Gauge(subscribeToStreams),
            widgetConfiguration.id,
            grid
        ));
        break;
      case 'Graph' :
        newWidgets.add(new Widget(
            graphModelFactory(subscribeToStreams, widgetConfiguration),
            widgetConfiguration.id,
            grid));
        break;
    }
  }

  Graph graphModelFactory(subscribeToStreams, widgetConfiguration) {
    var drawFromFirstEvent = widgetConfiguration.settings['drawFromFirstEvent'];
    var durationSettings = widgetConfiguration.settings['duration'];

    if (durationSettings != null) return graphWithDuration(durationSettings, drawFromFirstEvent, subscribeToStreams);
    else return new Graph(subscribeToStreams);

  }

  Graph graphWithDuration(durationSetting, drawFromFirstEvent, subscribeToStreams) {
    var milliseconds = durationSetting['milliseconds'] == null ? 0 : durationSetting['milliseconds'];
    var seconds = durationSetting['seconds'] == null ? 0 : durationSetting['seconds'];
    var minutes = durationSetting['minutes'] == null ? 0 : durationSetting['minutes'];
    var hours = durationSetting['hours'] == null ? 0 : durationSetting['hours'];
    var days = durationSetting['days'] == null ? 0 : durationSetting['days'];
    var duration = new Duration(
        milliseconds: milliseconds,
        seconds: seconds,
        minutes: minutes,
        hours: hours,
        days: days);

    if (drawFromFirstEvent != null) return
      new Graph(
          subscribeToStreams,
          drawFromFirstEvent: drawFromFirstEvent,
          duration: duration
      );
    else return
      new Graph(subscribeToStreams, duration: duration);

  }


}
