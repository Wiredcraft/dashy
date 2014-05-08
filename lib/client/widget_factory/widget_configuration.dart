part of dashy.widget_factory;

/**
 * The [WidgetConfiguration] object is responsible for deserializing a widget
 * configuration from a map parsed from the widgets configuration file by the
 * [WidgetFactory].
 */
class WidgetConfiguration {
  String id;
  Set dataSources = new Set();
  String type;
  Map settings = new Map();

  WidgetConfiguration.fromMap(map) {
    map.forEach((k, configurationOptions) {
      id = k;
      type = configurationOptions['type'];
      configurationOptions['attributes'].forEach((attributeOnWidget, dataSource) {
        dataSource.forEach((dataSource, attributeOnTimedEvent) {
          dataSources.add(dataSource);
        });
      });
      if (configurationOptions['settings'] != null) settings = configurationOptions['settings'];
    });
  }
}
