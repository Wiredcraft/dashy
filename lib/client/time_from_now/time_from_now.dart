library time_from_now;

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
class TimeFrom {
  String fromTimeString;
  TimeFrom();


  set setDateString(dateString) {
    fromTimeString = dateString;
  }

  get timeFromNow => toTimeLeft();


  String toTimeLeft() {
    if (fromTimeString == null) return '';

    var milestoneMoment = DateTime.parse(fromTimeString);
    var now = new DateTime.now();
    String _displayString;

    if (now.isAfter(milestoneMoment)) {
      _displayString = 'no time';
      return _displayString;
    }

    var timeRemaining = milestoneMoment.difference(now);

    int d = timeRemaining.inDays;
    int h = timeRemaining.inHours.remainder(Duration.HOURS_PER_DAY);
    int m = timeRemaining.inMinutes.remainder(Duration.MINUTES_PER_HOUR);
    int s = timeRemaining.inSeconds.remainder(Duration.SECONDS_PER_MINUTE);

    String days = (d == 0) ? '' : '$d days, ';
    String hours = (h == 0) ? '' : '$h hours, ';
    String minutes = (m == 0) ? '' : '$m minutes, ';
    String seconds = '$s seconds';

    _displayString = '$days$hours$minutes$seconds';
    return _displayString;
  }
}
