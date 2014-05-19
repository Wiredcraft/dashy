library dashy.widget_factory;


import 'dart:async';
import 'package:yaml/yaml.dart';
import 'package:angular/angular.dart';
import 'package:dashy/client/gauge/gauge.dart';
import 'package:dashy/client/graph/graph.dart';
import 'package:dashy/client/markdown/markdown.dart';
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

  broadcastWidget(WidgetConfiguration widgetConfiguration) {
    var subscribeToStreams = new List();

    widgetConfiguration.dataSources.forEach((dataSourceString) {
      subscribeToStreams.add(timedEventBroadcaster.registerDataSource(dataSourceString).stream);
    });

    switch (widgetConfiguration.type) {
      case 'Gauge' :
      //need to make list because of ng-repeat bug
      var gauges = new List.from(subscribeToStreams.map((stream) => new Gauge(stream)));
        newWidgets.add(new Widget(
            gauges,
            widgetConfiguration.id,
            grid
        ));
        break;

      case 'Graph' :
      var graphs = new List.from(subscribeToStreams.map((stream) => graphModelFactory(stream, widgetConfiguration)));
      newWidgets.add(new Widget(
          graphs,
          widgetConfiguration.id,
          grid));
      break;

      case 'Markdown' :
      var markdowns = new List.from(subscribeToStreams.map((stream) => new Markdown(stream)));

      List widgetModels = new List.from(markdowns);
      newWidgets.add(new Widget(
          widgetModels,
          widgetConfiguration.id,
          grid
      ));

      if (widgetConfiguration.settings['markdown'] != null) {
        new Timer(new Duration(seconds: 1), () {
          markdowns.forEach((markdown) =>
            markdown.update(
                new TimedEvent(null, null, null,
                  { 'markdown' : widgetConfiguration.settings['markdown'] },
                null)));
        });
      }
      break;
    }
  }

  Graph graphModelFactory(stream, widgetConfiguration) {
    var drawFromFirstEvent = widgetConfiguration.settings['drawFromFirstEvent'];
    var durationSettings = widgetConfiguration.settings['duration'];

    if (durationSettings != null) return graphWithDuration(durationSettings, drawFromFirstEvent, stream);
    else return new Graph(stream);
  }

  Graph graphWithDuration(durationSetting, drawFromFirstEvent, stream) {
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
          stream,
          drawFromFirstEvent: drawFromFirstEvent,
          duration: duration
      );
    else return
      new Graph(stream, duration: duration);

  }


}
