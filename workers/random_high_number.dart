import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

DateTime futureTime = new DateTime.now().add(new Duration(days: 28, minutes:23));
DateTime pastTime = new DateTime.now().subtract(new Duration(minutes:2, seconds: 50));
void main() {
  HttpClient client = new HttpClient();
  new Timer.periodic(new Duration(milliseconds:500), (_) { doCpuRequest(client); });
  new Timer.periodic(new Duration(seconds:10), (_) { doGitRequest(client); });
}

doCpuRequest(client) {
  client.openUrl('POST', Uri.parse('http://localhost:8081/some-datasource'))
  .then((HttpClientRequest req) {
    req.headers.contentType =
    new ContentType("application", "json", charset: "utf-8");
    var value = nextCpu();
    var mockData = {
        "time": new DateTime.now().toUtc().toIso8601String(),
        "data": {
            "value": value,
            "some-attribute" : new Random().nextInt(100),
            "some-time-in-the-future": futureTime.toUtc().toIso8601String(),
            "some-time-in-the-past": pastTime.toUtc().toIso8601String()
        }
    };

    print('sending ${mockData} to server');

    req.write(JSON.encode(mockData));
    return req.close();
  }).then((HttpClientResponse res) {
    res.listen(print);
  });
}

nextCpu() => new Random().nextInt(100);


doGitRequest(client) {
  client.openUrl('POST', Uri.parse('http://localhost:8081/git-datasource'))
  .then((HttpClientRequest req) {
    req.headers.contentType =
    new ContentType('application', 'json', charset: 'utf-8');
    var mockData = {
        'time': new DateTime.now().toUtc().toIso8601String(),
        'data': {
            'user' : 'Wiredcraft',
            'image' : 'https://gravatar.com/avatar/22ce4da11062511bc9a4eebbc8048c0d?d=https%3A%2F%2Fidenticons.github.com%2Fd6c567c0b18ff7bcbbaa395f5b1d1836.png&r=x',
            'title' : 'Updated styling on header'
        },
        'status': 'ok'
    };

    print('sending ${mockData} to server');

    req.write(JSON.encode(mockData));
    return req.close();
  }).then((HttpClientResponse res) {
    res.listen(print);
  });
}
