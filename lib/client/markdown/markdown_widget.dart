library markdown_widget;

import 'dart:html';
import 'package:dashy/client/markdown/markdown.dart';
import 'package:angular/angular.dart';
import 'package:markdown/markdown.dart' show markdownToHtml;


@Component(
    selector: 'markdown',
    templateUrl: 'packages/dashy/client/markdown/markdown.html',
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
  Markdown model;
  DirectiveMap directiveMap;
  DirectiveInjector directiveInjector;
  String latestStatus;


  MarkdownWidget(this.element, this.scope, this.compile, this.directiveInjector, this.directiveMap, this.injector);

  set setModel(_model) {
    model = _model;
    scope.context['model'] = model;
    scope
      ..watch('model.html', (newMarkdown, _) {
      if (newMarkdown != null) {
        var anchor =  new ViewPort(directiveInjector, scope, element.childNodes[0], injector.get(Animate));
        var newNodes = toNodeList(newMarkdown);
        anchor.insertNew(compile(newNodes, directiveMap), insertAfter: new View([element.childNodes[0]], scope));
      }
      })
      ..watch('model.status', (newStatus, _) {
      if (newStatus != null && newStatus != latestStatus) {
        if (latestStatus != null) element.classes.remove(latestStatus.toLowerCase());
        element.classes.add(newStatus.toLowerCase());
        latestStatus = newStatus;
      }
    });

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
