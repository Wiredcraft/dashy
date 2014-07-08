library config;

import 'dart:convert';
import 'dart:html';
import 'dart:js';
import 'package:angular/angular.dart';
import 'package:yaml/yaml.dart';
import 'package:dashy/client/app/app.dart';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/widget_factory/widget_factory.dart';

@Component(
  selector: 'widget-configuration',
  templateUrl: 'packages/dashy/client/widget/configuration.html',
  map: const {
    'configuration' : '=>setYamlConfiguration',
    'widget' : '=>setWidget',
    'widget-width' : '=>setWidth',
    'widget-height' : '=>setHeight'
  },
  publishAs: 'conf',
  useShadowDom: false
)
class ConfigurationWidget {
  var yamlConfiguration;
  Widget widget;
  App app;
  WidgetFactory widgetFactory;
  bool _validYaml = true;
  String _lastTry = '';


  String height = 0.toString();
  String widthFunction() => '${width}px';
  String width = 0.toString();
  String heightFunction() => '${height}px';

  get configuration {
    return _lastTry;
  }

  set configuration(_configuration) {
    print(_configuration);
    if (JSON.encode(loadYaml(_configuration)) != null) {
      _lastTry = _configuration;
      yamlConfiguration = loadYaml(_configuration);
      _validYaml = true;
    } else {
      _lastTry = _configuration;
      _validYaml = false;
    }
  }

  ConfigurationWidget(this.widgetFactory);

  save() {
    print('$yamlConfiguration saved');
    updateWidget(yamlConfiguration, widget.id);
  }

  updateWidget(Map widgetConfigurationMap, String id) {
    app.widgets.removeWhere((w) => w.id ==  id);
    widgetFactory.addWidget(app.widgets, widgetConfigurationMap);
  }

  set setWidth(_width) => width = _width.toString();

  set setHeight(_height) => height = _height.toString();

  set setYamlConfiguration(_configuration) {
    print(_configuration);
    _lastTry = context['YAML'].callMethod('stringify', [new JsObject.jsify(_configuration), 100, 2]);
    yamlConfiguration = _configuration;
  }

  set setWidget(_widget) => widget = _widget;
}
