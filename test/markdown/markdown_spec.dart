library markdown_spec;

import 'dart:async';
import '../_specs.dart';
import '../_test_module.dart';
import 'package:dashy/client/markdown/markdown_model.dart';
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
          Markdown markdown = new Markdown([messenger.stream]);

          scope.context['md'] = markdown;
          var element = e('<markdown model="md" probe="mdp"></markdown>');
          backend.expectGET('packages/dashy/client/markdown/markdown.html').respond(200,
          '');

          _.compile(element);

          var markdownProbe = scope.context['mdp'];
          markdownProbe.directive(MarkdownWidget);
          microLeap();
          scope.apply();
          backend.flush();

          expect(markdownProbe.element.innerHtml).toEqual('');

          messenger.add(markdownEvent);
          microLeap();
          scope.apply();
          expect(markdownProbe.element.innerHtml).toEqual('''
<h2>Such mark</h2>
<p><a href="load.markup">down</a></p>''');
        })));

    it('element should add classes based on status updates', async(
        inject(
                (TestBed _, MockHttpBackend backend, Scope scope, WidgetFactory factory, TimedEventBroadcaster timedEventBroadcaster) {
              var messenger = new StreamController();
              Markdown markdown = new Markdown([messenger.stream]);

              scope.context['md'] = markdown;
              var element = e('<markdown model="md" probe="mdp"></markdown>');
              backend.expectGET('packages/dashy/client/markdown/markdown.html').respond(200,
              '');

              _.compile(element);

              var markdownProbe = scope.context['mdp'];

              microLeap();
              scope.apply();
              backend.flush();

              expect(markdownProbe.element.classes.contains('ok')).toBeFalsy();
              TimedEvent statusEvent = new TimedEvent(null, null, null, null, 'ok');
              messenger.add(statusEvent);

              microLeap();
              scope.apply();
              expect(markdownProbe.element.classes.contains('ok')).toBeTruthy();

            }
        )));

    xit('component should compile markdown',
    async(
        inject((Scope scope, MockHttpBackend backend, TestBed _) {
          const SOME_MARKDOWN = '''
##Markup
That resolves a {{ scope.variable }}
          ''';

          TimedEvent markdownEvent = new TimedEvent(null, null, null, { 'markdown' : SOME_MARKDOWN}, null);
          var messenger = new StreamController();
          Markdown markdown = new Markdown([messenger.stream]);
          scope.context['md'] = markdown;
          var element = e('<markdown model="md" probe="mdp"></markdown>');
          backend.expectGET('packages/dashy/client/markdown/markdown.html').respond(200,
          '');
          backend.flush();
          _.compile(element);
          scope.context['variable'] = 'variable';

          var markdownProbe = scope.context['mdp'];
//          markdownProbe.directive(MarkdownWidget);

          messenger.add(markdownEvent);
          microLeap();
          scope.rootScope.apply();
          expect(markdownProbe.element.innerHtml).toEqual('''
<h2>Markup</h2>
<p>That resolves a, variable</p>''');
        })));
  });

}

