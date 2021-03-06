library app_component_spec;

import 'package:dashy/client/app/app.dart';
import 'package:dashy/client/app/app_component.dart';
import '../_test_module.dart';
import '../_specs.dart';


main() {
  TestBed _;
  describe('app', () {
    beforeEachModule((Module module) {
      module..install(new MockDashyModule());

      return (TestBed tb) => _ = tb;
    });

    it('should query for widgets', async(
      inject((Compiler compile, Injector injector, MockHttpBackend backend,
              RootScope scope, DirectiveMap directives) {

        backend
          ..whenGET('packages/dashy/client/app/app.html').respond('''
        <widget ng-repeat="widget in app.model.widgets" model="widget
        .model"></widget>
        ''')
          ..whenGET('packages/dashy/client/widget/widget.html').respond('''
            <gauge gauge="model" ng-repeat="model in widg.model" probe="gp" ng-if="widg.isGauge()">
            </gauge>
        ''');

        var element = e('<app probe="ap"></app>');

        compile([element], injector.get(DirectiveMap))(scope, null);
        Probe appProbe = _.rootScope.context['ap'];

        AppComponent appComponent = appProbe.directive(AppComponent);

        App app = appComponent.app;
        microLeap();

        expect(app.widgets.length).toBe(3);
        clockTick(seconds:1);

      })));

  });
}
