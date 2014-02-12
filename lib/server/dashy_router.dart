part of dashy_server;


var timedEventRoutePattern = new UrlPattern(r'/event/(\d+)');

class DashyRouter extends Router {
  DashyRouter(http, timedEventFlow) : super(http) {
    serve(timedEventRoutePattern)
      .listen(handleTimedEventRequest(timedEventFlow));

    defaultStream.listen(serveDirectory('web', as: '../../../../'));
  }
}


handleTimedEventRequest(TimedEventFlows timedEventFlows) 
  => (HttpRequest req) {
  var body = [];
    req.listen((stream) => body.addAll(stream), 
        onDone: () { 
          req.response.write('kthxbai');
          req.response.close();
          timedEventFlows.add(timedEventRoutePattern.parse(req.uri.path)[0], 
              JSON.decode(UTF8.decode(body)));
        });
};
