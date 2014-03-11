part of dashy_server;

var timedEventPattern = r'/event/(\d+)';
var tokenRequestPattern = r'/token';
var widgetStreamPattern = r'/widgets';
var random = new Random();
/**
 * Sets up all the routes to their handlers. 
 */
class DashyRouter extends Router {
  DashyRouter(http, timedEventFlow, uuid) : super(http) {
    serve(timedEventPattern, method: 'POST')
      .listen(handleTimedEventRequest(timedEventFlow));
    serve(tokenRequestPattern, method: 'GET')
      .listen(handleTokenRequest(uuid));
    serve(widgetStreamPattern, method: 'GET')
      .listen((req) => WebSocketTransformer.upgrade(req).then(print));
    serve('/ws')
      .transform(new WebSocketTransformer())
      .listen(handleWebSocket);
    var buildPath = Platform.script.resolve('../build/web').toFilePath();
      if (!new Directory(buildPath).existsSync()) {
        print("The 'build/' directory was not found. Please run 'pub build'.");
        return;
      }
      

    // Set up default handler. This will serve files from our 'build' directory.
     var virDir = new VirtualDirectory(buildPath);
     // Disable jail root, as packages are local symlinks.
     virDir.jailRoot = false;
     virDir.allowDirectoryListing = true;
     virDir.directoryHandler = (dir, request) {
       // Redirect directory requests to index.html files.
       var indexUri = new Uri.file(dir.path).resolve('index.html');
       virDir.serveFile(new File(indexUri.toFilePath()), request);
     };
     
     virDir.errorPageHandler = (HttpRequest request) {
           print("Resource not found: ${request.uri.path}");
           request.response.statusCode = HttpStatus.NOT_FOUND;
           request.response.close();
         };  
         
     virDir.serve(defaultStream);
     
// Special handling of client.dart. Running 'pub build' generates
 // JavaScript files but does not copy the Dart files, which are
 // needed for the Dartium browser.
 serve("/dashy.dart").listen((request) {
   Uri clientScript = Platform.script.resolve("../web/dashy.dart");
   virDir.serveFile(new File(clientScript.toFilePath()), request);
 });
  }
}

handleWebSocket(WebSocket webSocket) {
  print('new WebSocket connection');
  webSocket.map((messageString) => JSON.decode(messageString))
  .listen((messageJson) {
    var request = messageJson['request'];
    switch (request) {
      case 'CPU':
        var input = messageJson['input'];
        print(input);
        webSocket.add(JSON.encode({ 'response' :  random.nextDouble(1.0)}));
      break;
    }
  });
}

handleTimedEventRequest(TimedEventFlows timedEventFlows)
  => (HttpRequest req) {
  var body = [];
    req.listen((stream) => body.addAll(stream), 
        onDone: () { 
          req.response.write('kthxbai');
          req.response.close();
          timedEventFlows.add(timedEventPattern.parse(req.uri.path)[0], 
              JSON.decode(UTF8.decode(body)));
        });
};

handleTokenRequest(UuidBase uuid) =>
    (HttpRequest req) {
    req.response.write(uuid.v1());
    req.response.close();
};