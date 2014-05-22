library time_from_now_spec;

import 'dart:async';
import '../_specs.dart';
import '../_test_module.dart';
import 'package:dashy/client/markdown/markdown.dart';
import 'package:dashy/client/markdown/markdown_widget.dart';
import 'package:dashy/client/time_from_now/time_from_now.dart';
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

    it('should format a date in the future',
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
          backend.expectGET('packages/dashy/client/markdown/markdown.html').respond(200,'<!-- anchor -->');

          _.compile(element, scope: scope);

          Probe markdownProbe = scope.context['mdp'];
          microLeap();
          backend.flush();
          microLeap();

          expect(markdownProbe.element.innerHtml).toEqual('<!-- anchor -->');

          messenger.add(markdownEvent);
          microLeap();
          scope.apply();
          microLeap();

          TimeFromNow component = markdownProbe.directive(TimeFromNow);
          clockTick(seconds: 1);
          expect(markdownProbe.element.innerHtml).toEqual('''
<!-- anchor --><timefromnow for-date="comp.model['event-in-the-future']" class="ng-binding">2 days, 2 minutes, 59 seconds</timefromnow>''');

          component.timer.cancel();
        })));

    it('should format a date in the past',
    async(
        inject((Scope scope, MockHttpBackend backend, TestBed _) {
          const SOME_MARKDOWN = '''
<timefromnow for-date="comp.model['event-in-the-future']"></timefromnow>
          ''';

          DateTime now = new DateTime.now();
          DateTime in2DaysAnd3Minutes = now.subtract(new Duration(days: 2, minutes: 3));

          TimedEvent markdownEvent = new TimedEvent(null, null, null,
          { 'event-in-the-future': in2DaysAnd3Minutes.toUtc().toIso8601String(),
              'markdown' : SOME_MARKDOWN},
          null);

          var messenger = new StreamController();
          Markdown markdown = new Markdown(messenger.stream);
          scope.context['md'] = markdown;
          var element = e('<markdown model="md" probe="mdp"></markdown>');
          backend.expectGET('packages/dashy/client/markdown/markdown.html').respond(200,'<!-- anchor -->');

          _.compile(element, scope: scope);

          Probe markdownProbe = scope.context['mdp'];
          microLeap();
          backend.flush();
          microLeap();

          expect(markdownProbe.element.innerHtml).toEqual('<!-- anchor -->');

          messenger.add(markdownEvent);
          microLeap();
          scope.apply();
          microLeap();

          TimeFromNow component = markdownProbe.directive(TimeFromNow);
          clockTick(seconds: 1);
          expect(markdownProbe.element.innerHtml).toEqual('''
<!-- anchor --><timefromnow for-date="comp.model['event-in-the-future']" class="ng-binding">2 days, 3 minutes, 0 seconds ago</timefromnow>''');

          component.timer.cancel();
        })));


  });

}
