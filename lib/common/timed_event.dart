library dashboard_model;


class TimedEvent {
  String id;
  String datasource;
  DateTime time;
  Map<String, String> data;
  
  TimedEvent(this.id, this.datasource, this.time, this.data);

 
  TimedEvent.fromJson(Map json) {
    data = json['data'];
    datasource = json['datasource'];
    id = json['id'];
    time = DateTime.parse(json['time']);
  }

  Map toJson() {
    return {'data' : data, 'datasource' : datasource, 'id' : id, 'time' : time};
  }
}
