library status_widget;

import 'package:angular/angular.dart';

@Component(
    selector: 'status',
    publishAs: 'comp',
    templateUrl: 'packages/dashy/client/status/status.html',
    map: const {
        'model' : '=>model'
    },
    useShadowDom: false
)
class StatusWidget {
  dynamic model;

  StatusWidget();
}
