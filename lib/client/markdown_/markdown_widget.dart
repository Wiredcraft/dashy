library markdown_widget;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:markdown/markdown.dart' show markdownToHtml;


@Component(
  selector: 'markdown',
  map: const {
    'model': '=>setModel'
  },
  publishAs: 'comp',
  useShadowDom: false
)
class MarkdownWidget {
  Element element;
  String markdown;
  Scope scope;
  Compiler compile;
  Injector injector;

  DirectiveMap directives;
  String latestStatus;

  MarkdownWidget(this.element, this.scope, this.compile, this.directives);
  set setModel(model) {
    //watch markdown and status
    scope
      ..watch('html', (newMarkdown, _) {
        if (newMarkdown != null) {
//          var rootElements = toNodeList(
              element.setInnerHtml(newMarkdown);
//          );
//          compile(rootElements, directives)
//                 (injector, rootElements);
        }
      }, context: model)
      ..watch('status', (newStatus, _) {
        if (newStatus != null && newStatus != latestStatus) {
          if (latestStatus != null) element.classes.remove(latestStatus.toLowerCase());
          element.classes.add(newStatus.toLowerCase());
          latestStatus = newStatus;
        }
      }, context: model);

  }

  List<Element> toNodeList(html) {
    var div = new DivElement();
    div.setInnerHtml(html, treeSanitizer: new NullTreeSanitizer());
    var nodes = [];
    for (var node in div.nodes) {
      nodes.add(node);
    }
    return nodes;
  }
}
