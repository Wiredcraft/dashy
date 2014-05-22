library time_from_now;

import 'dart:async';
import 'package:angular/angular.dart';

@Component(
    selector: 'timefromnow',
    template: '{{ comp.timeFromNow }}',
    publishAs: 'comp',
    map: const {
      'for-date' : '=>setDateString'
    },
    useShadowDom: false
)
class TimeFromNow implements DetachAware {
  String fromTimeString;
  Timer timer;

  Scope scope;

  TimeFromNow(this.scope) {
    timer = new Timer.periodic(new Duration(seconds:1), (_) {
      scope.apply();
    });
  }


  set setDateString(dateString) {
    fromTimeString = dateString;
  }

  get timeFromNow => toTimeLeft();

  detach() {
    timer.cancel();
  }

  String toTimeLeft() {
    if (fromTimeString == null) return '';
    if (timer != null) timer.cancel();

    var milestoneMoment = DateTime.parse(fromTimeString);
    var now = new DateTime.now();
    String _displayString;
    var timeRemaining;
    if (now.isAfter(milestoneMoment)) {
      timeRemaining = now.difference(milestoneMoment);
    } else {
      timeRemaining = milestoneMoment.difference(now);
    }

    int d = timeRemaining.inDays;
    int h = timeRemaining.inHours.remainder(Duration.HOURS_PER_DAY);
    int m = timeRemaining.inMinutes.remainder(Duration.MINUTES_PER_HOUR);
    int s = timeRemaining.inSeconds.remainder(Duration.SECONDS_PER_MINUTE);

    String days = (d == 0) ? '' : '$d days, ';
    String hours = (h == 0) ? '' : '$h hours, ';
    String minutes = (m == 0) ? '' : '$m minutes, ';
    String seconds = '$s seconds';

    _displayString = '$days$hours$minutes$seconds';
    if (now.isAfter(milestoneMoment)) _displayString += ' ago';


    return _displayString;
  }
}
