part of dashy.widget_factory;

/**
 * The [WidgetConfiguration] object is responsible for deserializing a widget
 * configuration from a map parsed from the widgets configuration file by the
 * [WidgetFactory].
 */
@Injectable()
class WidgetConfiguration {
  String id;
  List dataSources = new List();
  String type;
  Map settings = new Map();
  int x;
  int y;
  int w;
  int h;

  WidgetConfiguration();

  WidgetConfiguration.fromMap(map) {
    map.forEach((k, configurationOptions) {
      id = k;
      type = configurationOptions['type'];

      configurationOptions['attributes'].forEach((dataSource) {
          dataSources.add(dataSource);
      });

      if (configurationOptions['settings'] != null) settings = configurationOptions['settings'];
      if (configurationOptions['layout'] != null) {
        x = configurationOptions['layout']['x'] != null ? configurationOptions['layout']['x'] : 0;
        y = configurationOptions['layout']['y'] != null ? configurationOptions['layout']['y'] : 0;
        w = configurationOptions['layout']['w'] != null ? configurationOptions['layout']['w'] : 0;
        h = configurationOptions['layout']['h'] != null ? configurationOptions['layout']['h'] : 0;
      }
    });
  }
}
