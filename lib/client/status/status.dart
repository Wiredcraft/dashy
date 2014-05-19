library status;

import 'dart:async';
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';



/**
 * The [Status] class is responsible for updating the Status type components
 * model in an appropriate manner.
 */
class Status {

  Status(Iterable<Stream> timedEventStreams) {
    timedEventStreams.forEach((stream) => stream.listen(update));
  }

  update(TimedEvent timedEvent) {
    
  }

}
