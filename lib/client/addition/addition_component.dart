library addition;

import 'dart:html';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/grid/drag_n_drop.dart';
import 'package:dashy/client/grid/grid.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'filler-widget',
  publishAs: 'addc',
  template: '',
  map: const {
    'widget-model' : '=>widget',
    'app-height': '=>appHeight'
  },
  useShadowDom: false
)
class FillerWidget {
  DndGrid dndGrid;
  Widget _widget;
  Element element;
  Scope scope;
  Grid grid;

  var _appHeight = 0;

  FillerWidget(this.dndGrid,  this.element, this.grid, this.scope);

  int get cellSize  => (_appHeight / grid.maxRow).floor();

  set appHeight(appHeight) {
    _appHeight = appHeight;
    scope.context['cellSize'] = cellSize;
  }

  set widget(Widget widget){
    scope.context['widget'] = widget;

    _widget = widget;
    dndGrid.registerDropzoneWidget(element, widget);

    scope
      ..watch('widget.x', (newX, _) {
      element.style.left = '${newX * cellSize}px';
    })

      ..watch('widget.y', (newY, _) {
      element.style.top = '${newY * cellSize}px';
    })

      ..watch('widget.w', (newW, _) {
      element.style.width = '${newW * cellSize}px';
    })

      ..watch('widget.h', (newH, _) {
      element.style.height = '${newH * cellSize}px';
    });

  }

}
