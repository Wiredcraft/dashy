##New direction for dashy

New version of dashy using Dart & Redis

Running project:

Install:
Dart & Redis

You can download the official [Dart Editor](https://www.dartlang.org/tools/download.html),
 download plug-ins for your favorite IDE, or just download the dart-sdk and run
 the scripts from the command line.

Dart, just like JavaScript runs on the server and client. In order to run you 
need to have the `dart-sdk` binaries installed and run the following command from 
the root directory:

    `dart server.dart' 

this will start the WebServer, connect to Redis and starts
listening to webrequests on `localhost:1337/index.html`.


##Accessing the API.
The Web-App will provide the user with a datasource-identifying `DataSourceToken`.
This token can be used to link a datasource/worker that is making POST requests 
to the the following URL: `localhost:1337/event/SOME_TOKEN`


##The architecture

The architecture can be described by these concepts:

A _TimedEvent_ which can be serialized to the following JSON format:

A _DashyServer_ that listens to incoming HTTP requests, handling serving the 
web-assets and providing an API for incoming _TimedEvents_.

Handling the HttpRequests is the _DashyRouter_, it listens to the HttpServer and
spins up handler functions that move the HttpRequests where they need to go.

When a _DataSource_ makes a call to the API the handler will invoke the 
_TimedEventFlows_ object to match the _DataSourceToken_ to a StreamController.
The HttpRequest will then be read and transformed into a TimedEvent, which will
be added to the StreamController.

-below not implemented yet-
Interested in this _TimedEventFlow_ (StreamController) is _RedisStorage_ which 
stores the TimedEvents.

Also interested in this _TimedEventFlow_ will be the WebApp, which will receive 
an event via WebSockets and update it's widgets accordingly. 

In order to register the datasource the configuring user receives from the 
_WebApp_ a _DataSourceToken_. Which the datasource service uses in the URL of its' POST 
request to the API.

The _WebApp_ has a _DataSourceConfigurationView_ in which the
_DataSourceToken(s)_ are presented. The user can add new widgets in the 
_WidgetsView_ where pressing the add button will show the _WidgetMappingView_ 
which will contain 2 views: one to select a _WidgetType_ and the other to map 
required/optional configuration options for the _WidgetType_.

An additional _DashboardsView_ enables the configuring user to import and 
export dashboards and widgets using a YAML format.


