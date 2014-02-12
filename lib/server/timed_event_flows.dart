part of dashy_server;
/**
 * TimedEventFlows manage the [TimedEvents] and makes sure the right TimedEvent 
 * ends up at the right user.
 */
class TimedEventFlows {
  
  Map<String, StreamController<TimedEvent>> timedEventStreamMap = {};
  
  add(tokenString, data) {
    timedEventStreamMap.putIfAbsent(tokenString, () => 
        new StreamController<TimedEvent>());
    timedEventStreamMap[tokenString].add(new TimedEvent.fromJson(data));
  }
  
}
