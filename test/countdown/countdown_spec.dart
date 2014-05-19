library markdown_spec;

import 'dart:async';
import '../_specs.dart';
import '../_test_module.dart';
import 'package:dashy/client/markdown/markdown.dart';
import 'package:dashy/client/markdown/markdown_widget.dart';
import 'package:dashy/client/widget_factory/widget_factory.dart';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';

main() {
  describe('time-from-now', () {
    TestBed _;
    beforeEachModule((Module module) {
      module
        ..install(new MockDashyModule());

      return (TestBed tb) => _ = tb;
    });

    xit('should format a date in the future',
    async(
        inject((Scope scope, MockHttpBackend backend, TestBed _) {
          const SOME_MARKDOWN = '''
<timefromnow for-date="comp.model['event-in-the-future']"></timefromnow>
          ''';

          DateTime now = new DateTime.now();
          DateTime in2DaysAnd3Minutes = now.add(new Duration(days: 2, minutes: 3));

          TimedEvent markdownEvent = new TimedEvent(null, null, null,
          { 'event-in-the-future': in2DaysAnd3Minutes.toUtc().toIso8601String(),
              'markdown' : SOME_MARKDOWN},
          null);

          var messenger = new StreamController();
          Markdown markdown = new Markdown(messenger.stream);
          scope.context['md'] = markdown;
          var element = e('<markdown model="md" probe="mdp"></markdown>');
          backend.expectGET('packages/dashy/client/markdown/markdown.html').respond(200,'');

          _.compile(element, scope: scope);

          var markdownProbe = scope.context['mdp'];

          messenger.add(markdownEvent);
          scope.apply();
          microLeap();
          backend.flush();
          scope.apply();
          expect(markdownProbe.element.innerHtml).toEqual('''
<div><!-- anchor --><timefromnow for-date="comp.model['event-in-the-future']" class="ng-binding">2 days, 2 minutes, 59 seconds</timefromnow></div>''');
        })));
  });

}

