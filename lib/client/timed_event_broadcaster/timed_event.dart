part of timed_event_broadcaster;

/**
 * The [TimedEvent] is what all the new update messages from the dashy server
 * get translated to.
 */
class TimedEvent {
  String id;
  String dataSource;
  DateTime time;
  Map<String, dynamic> data;
  
  TimedEvent(this.id, this.dataSource, this.time, this.data);


  factory TimedEvent.fromJson(json) {
    return new TimedEvent(json['id'], json['datasource'],
    DateTime.parse(json['time']), json['data']);
  }

  Map toJson() {
    return {'data' : data, 'datasource' : dataSource, 'id' : id, 'time' : time};
  }
}
