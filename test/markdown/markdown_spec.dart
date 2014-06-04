library markdown_spec;

import 'dart:async';
import '../_specs.dart';
import '../_test_module.dart';
import 'package:dashy/client/markdown/markdown.dart';
import 'package:dashy/client/markdown/markdown_widget.dart';
import 'package:dashy/client/widget_factory/widget_factory.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';

main() {
  describe('markdown', () {
    TestBed _;
    beforeEachModule((Module module) {
      module
      ..install(new MockDashyModule());

      return (TestBed tb) => _ = tb;
    });

    it('component should compile markdown',
    async(
        inject((Scope scope, MockHttpBackend backend, TestBed _) {
          const SOME_MARKDOWN = '''
##Such mark
[down](load.markup)
          ''';

          TimedEvent markdownEvent = new TimedEvent(null, null, null, { 'markdown' : SOME_MARKDOWN}, null);
          var messenger = new StreamController();
          Markdown markdown = new Markdown()..addStream(messenger.stream);

          scope.context['md'] = markdown;
          backend.expectGET('packages/dashy/client/markdown/markdown.html').respond(200,'<!-- anchor -->');
          var element = e('<markdown model="md" probe="mdp"></markdown>');

          _.compile(element);
          var markdownProbe = scope.context['mdp'];

          microLeap();
          backend.flush();
          microLeap();

          expect(markdownProbe.element.innerHtml).toEqual('<!-- anchor -->');

          messenger.add(markdownEvent);
          microLeap();
          scope.apply();

          expect(markdownProbe.element.innerHtml).toEqual('''
<!-- anchor --><h2 class="ng-binding">Such mark</h2>
<p class="ng-binding"><a href="load.markup" class="ng-binding">down</a></p>''');
        })));

    it('element should add classes based on status updates', async(
        inject(
                (TestBed _, MockHttpBackend backend, Scope scope, WidgetFactory factory, TimedEventBroadcaster timedEventBroadcaster) {
              var messenger = new StreamController();
              Markdown markdown = new Markdown()..addStream(messenger.stream);

              scope.context['md'] = markdown;
              var element = e('<markdown model="md" probe="mdp"></markdown>');
              backend.expectGET('packages/dashy/client/markdown/markdown.html').respond(200,'');

              _.compile(element);

              var markdownProbe = scope.context['mdp'];

              microLeap();
              scope.apply();
              backend.flush();

              expect(markdownProbe.element.classes.contains('ok')).toBeFalsy();
              TimedEvent statusEvent = new TimedEvent(null, null, null, {}, 'ok');
              messenger.add(statusEvent);

              microLeap();
              scope.apply();
              expect(markdownProbe.element.classes.contains('ok')).toBeTruthy();

            }
        )));

    it('component should compile markdown and watch attributes',
    async(
        inject((Scope scope, MockHttpBackend backend, TestBed _) {
          const SOME_MARKDOWN = '''
##Markdown
That resolves an, {{ comp.model['attribute'] }}
          ''';

          TimedEvent markdownEvent = new TimedEvent(null, null, null,
          { 'attribute': 'attribute',
              'markdown' : SOME_MARKDOWN},
          null);

          var messenger = new StreamController();
          Markdown markdown = new Markdown()..addStream(messenger.stream);
          scope.context['md'] = markdown;
          var element = e('<markdown model="md" probe="mdp"></markdown>');
          backend.expectGET('packages/dashy/client/markdown/markdown.html').respond(200,'<!-- anchor -->');
          _.compile(element, scope: scope);

          var markdownProbe = scope.context['mdp'];

          messenger.add(markdownEvent);
          scope.apply();
          microLeap();
          backend.flush();
          microLeap();
          scope.apply();
          expect(markdownProbe.element.innerHtml).toEqual('''
<!-- anchor --><h2 class="ng-binding">Markdown</h2>
<p class="ng-binding">That resolves an, attribute</p>''');
        })));

  });

}

