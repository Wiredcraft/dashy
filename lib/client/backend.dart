library widgets_backend;

import 'package:angular/angular.dart';
import 'package:dashy/client/model/widget.dart';
import 'dart:convert';

const BACKEND_ADDRESS = 'http://localhost:37331';

class WidgetsBackend {
  Http _http;
  
  WidgetsBackend(this._http);
  
  getWidgets(ctrl) {
    _http(method: 'GET', url: '$BACKEND_ADDRESS/widgets')
      .then((HttpResponse res) => ctrl.widgets = res.data.map(newWidget));
  }
  
  newWidget(json) => new Widget.fromJson(JSON.decode(json));
}