library dnd_grid;

import 'dart:html';
import 'dart:async';
import 'package:dashy/client/app/app.dart';
import 'package:dashy/client/grid/grid.dart';
import 'package:dashy/client/widget/widget.dart';
import 'package:dashy/client/addition/addition_factory.dart';
import 'package:html5_dnd/html5_dnd.dart';
import 'package:angular/angular.dart';

@Injectable()
class DndGrid {
  Grid grid;
  App app;
  FillerWidgetFactory fillerWidgetFactory;

  final Map<DraggableGroup, Widget> draggableWidgets = new Map();
  final Map<DropzoneGroup, Widget> dropzoneWidgets = new Map();

  get draggables => draggableWidgets.keys.toSet();
  get dropzones => dropzoneWidgets.keys.toSet();

  DndGrid(this.grid, this.app, this.fillerWidgetFactory);

  registerWidget(Element element, Widget widget) {
    createDraggable(element, widget);

    createDropzone(element, widget);
    app.fillerWidgets.clear();
    app.fillerWidgets.addAll(fillerWidgetFactory());
  }

  createDraggable(Element element, Widget widget) {
    var draggable = new DraggableGroup()..install(element);
    draggableWidgets[draggable] = widget;
    return draggable;
  }

  createDropzone(Element element, Widget widget) {
    var dropzone = new DropzoneGroup()..install(element);
    dropzoneWidgets[dropzone] = widget;

    dropzones.forEach(updateAcceptedDraggables);

    dropzone.onDrop.listen((DropzoneEvent event) {
      var draggableWidget = draggableWidgets[draggables.firstWhere(
              (draggable) => draggable.installedElements.containsKey(event.draggable))];

      var dropzoneWidget = dropzoneWidgets[dropzones.firstWhere(
              (dropzone) => dropzone.installedElements.containsKey(event.dropzone))];

      if (dropzoneWidget != draggableWidget) {
        Set collidedWidgets = grid.add(draggableWidget,
        at: new Rectangle(dropzoneWidget.x, dropzoneWidget.y, draggableWidget.w, draggableWidget.h));

        collidedWidgets.forEach(updateLocation);

        app.fillerWidgets.clear();
        app.fillerWidgets.addAll(fillerWidgetFactory());
      }
    });

  }

  registerDropzoneWidget(Element element, Widget widget) {
    createDropzone(element, widget);
  }


  updateAcceptedDraggables(DropzoneGroup dropzone) {
    dropzone.accept = draggables;
  }

  updateLocation(Widget widget) {
    var newLocation = grid.areaExtractor(widget);
    widget.x = newLocation.left;
    widget.y = newLocation.top;
  }

}
