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
    'configuration' : '=>setConfiguration',
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

  String height = 0.toString();
  String widthFunction() => '${width}px';
  String width = 0.toString();
  String heightFunction() => '${height}px';

  get configuration {
    return context['YAML'].callMethod('stringify', [new JsObject.jsify(yamlConfiguration), 100, 2]);
  }

  set configuration(_configuration) {
//    try {
//      if (JSON.encode(loadYaml(configuration)) != JSON.encode(loadYaml(_configuration))) {
//        print('able to parse');
//      }
//    } catch (e) {
//      print('parseerror');
//    }
    yamlConfiguration = _configuration;
  }

  ConfigurationWidget(this.app, this.widgetFactory);

  set setWidth(_width) => width = _width.toString();

  set setHeight(_height) => height = _height.toString();

  set setConfiguration(_configuration) => yamlConfiguration = _configuration;

  set setWidget(_widget) => widget = _widget;
}

