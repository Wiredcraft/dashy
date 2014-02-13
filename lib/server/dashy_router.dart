part of dashy_server;



var timedEventRoutePattern = new UrlPattern(r'/event/(\d+)');
var tokenRequestRoutePattern = new UrlPattern(r'/token');

class DashyRouter extends Router {
  DashyRouter(http, timedEventFlow, uuid) : super(http) {
    serve(timedEventRoutePattern, method: 'POST')
      .listen(handleTimedEventRequest(timedEventFlow));
    serve(tokenRequestRoutePattern, method: 'GET')
      .listen(handleTokenRequest(uuid));
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

handleTokenRequest(Uuid uuid) =>
    (HttpRequest req) {
    req.response.write(uuid.v1());
    req.response.close();
};
