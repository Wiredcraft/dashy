#Dashy

Dashy is a low profile dashboard app. It is a simple API endpoint that
listens to post requests with new _events_. Dashy tries to be as non invasive as
 possible when it comes to data collection, data collection will be done by
 workers that the user provides himself. These workers are _DataSources_ in
 Dashy lingo, and push their _events_ to a "webhook" address that the dashy
 server listens to.
 This dashy server also hosts the dashboard web app and lets the user
 configure _widgets_. The different types of widgets can make known which
 attributes on which datasources they want to subscribe to. By attributes is
 meant the keys of the "data" map that an event contains:
```
{
"time" : UTCTIMESTAMP,
"data" : {
  "some-attribute" : "some-value",
  "some-other-attribute" : "some-value"
  }
}
```


##Development dependencies:
Dart, Go & Redis

You can download the official [Dart Editor](https://www.dartlang.org/tools/download.html),
 download plug-ins for your favorite IDE, or just download the dart-sdk and run
 the scripts from the command line.

Go is installed by following the steps at  [http://golang.org/doc/install]
(http://golang.org/doc/install)


##Using dashy
  - Write a .yaml file outlining the configuration of a datasource and put it
   in the web/sources/ folder. A configuration for the CPU datasource would
   look like this:
```yaml
name: Cpu Pretty Name
webhooks:
        - h31i-asdj-23ja-zxm9 #obscure webhook
        - CPU-webhook
```

 - Write a .yaml file outlining the widgets configurations. The widget
 declares in which looks like the following:

```yaml
widgets:
- some-widget-id:
    attributes:
      attribute-name:
        DATASOURCE_ID: attribute-name
    type: Gauge
```

  - Start the server, which will set up listeners for all the webhooks found in
  the .yaml files. So now the workers can push POST requests to the webhooks
  they registered in the datasource configuration yaml.
  - Go to localhost:8081 to view dashboard.


##The architecture

The architecture of the server revolves for a great deal around Channels.
On the client side this is comparable to the StreamController. They are
asynchronous messaging mechanisms.

The Client side:

App
The App model is responsible for maintaining a collection of Widgets.

WebSocketWrapper
The WebSocketWrapper has the responsibility of keeping the messages from the back-end flowing to the MessageRouter. It maintains the connection and deserializes incoming messages before sending them of to the MessageRouter

MessageRouter
The MessageRouter is responsible for sending the incoming messages from the right recipient. For instance on a new "update" type message from the WebSocketsWrapper, this will send a new TimedEvent to the TimedEventBroadcaster.

TimedEvent
The TimedEvent is what all the new update messages from the dashy server get translated to.

TimedEventBroadcaster
The TimedEventBroadcaster is responsible for coordinating the flow of new TimedEvents to the registered objects. It is a step in the configuration of a new WidgetModel where it maps the DataSources to StreamControllers and then listens to new TimedEvent on the [newMessages] [StreamController].

Widget
Contains information on the layout of the widget and which type it is. Its "type" is inferred by the model variable.

WidgetComponent
The widgetComponent has the responsibility of keeping the widgets model to the view and loading the correct type of widget.

WidgetConfiguration
The WidgetConfiguration object is responsible for deserialising a widget
configuration from a map parsed from the widgets configuration file by the WidgetFactory.

WidgetFactory
The WidgetFactory creates widgets based on configuration. It converts a configuration yaml string to new widgets which need the TimedEventBroadcaster to subscribe to the datasources they are interested in. Finally it uses the newWidgets StreamController to add new widgets to the Apps' model
