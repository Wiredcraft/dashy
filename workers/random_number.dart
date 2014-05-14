import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';


void main() {
  HttpClient client = new HttpClient();
  new Timer.periodic(new Duration(milliseconds:1000), (_) { doRequest(client); });
}

doRequest(client) {
  client.openUrl('POST', Uri.parse('http://localhost:8081/some-datasource'))
  .then((HttpClientRequest req) {
    req.headers.contentType =
    new ContentType("application", "json", charset: "utf-8");
    var mockData = {
        "time": new DateTime.now().toUtc().toIso8601String(),
        "data": {
            "value": new Random().nextInt(100),
            "some-attribute" : new Random().nextInt(100)
        }
    };

    print('sending ${mockData} to server');

    req.write(JSON.encode(mockData));
    return req.close();
  }).then((HttpClientResponse res) {
    res.listen(print);
  });
}
