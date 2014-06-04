library markdown_model;

import 'package:markdown/markdown.dart' show markdownToHtml;
import 'package:dashy/client/timed_event_broadcaster/timed_event_broadcaster.dart';


class Markdown implements TimedEventAware {
  String html;
  String status = '';
  Map attributes = new Map();

  Markdown();

  update(TimedEvent timedEvent) {
    if (timedEvent.data != null) attributes.addAll(timedEvent.data);

    if (timedEvent.data != null && timedEvent.data['markdown'] != null) {
      html = markdownToHtml(timedEvent.data['markdown']);
    }
    if (timedEvent.status != null) status = timedEvent.status;
  }

  addStream(stream) {
    stream.listen(update);
  }

  operator [](key) => attributes[key];

}
