library components_tests;

import 'dart:html';
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:dashy/client/component/widgets/widgets_component.dart';
import 'package:dashy/client/controller/main_controller.dart';
import 'package:dashy/client/backend.dart';



const WIDGETS_COMPONENT_HTML = '''
<div main-controller> 
  <widgets></widgets>
</div>
'''; 

main() {
    var testBed, httpBackend;
    
    
}
