library dashy;

@MirrorsUsed(override: '*')
import 'dart:mirrors';
import 'dart:convert';
import 'dart:html';
import 'dart:async';
import 'package:di/di.dart';
import 'package:di/dynamic_injector.dart';
import 'package:angular/application_factory.dart';
import 'package:dashy/client/dashy.dart';

void main() {
  var angularInjector = applicationFactory().createInjector();
  var angularTypes = angularInjector.types;
  var injWithOwnClasses = applicationFactory().addModule(new DashyModule()).run();
  var injector = injWithOwnClasses.types.difference(angularTypes);
  var depExtractor = new DependencyExtractor();
  var wsInjector = new DynamicInjector(modules: [new ClassHierarchyModule()]);
  var webSocketWrapper = wsInjector.get(WebSocketWrapper);
  webSocketWrapper.webSocket.onOpen.listen((e) {
    webSocketWrapper.webSocket.send(JSON.encode({'request' : 'take-dependencies', 'data' : depExtractor(injector) }));
    print('sending ${depExtractor(injector)}');
  });

  var jsArg = JSON.encode({
      'container': 'container',
      'graph' : {'nodes' : []}
  });
}

class ClassHierarchyModule extends Module {
  ClassHierarchyModule() {
    bind(WebSocketWrapper);
    bind(MessageRouter);
  }
}

class DependencyExtractor {
  call(injector) {
    Map<Type, List<Type>> typeConstructorDependencies = {};

    addDependency(int pos, MethodMirror constructor) {
      ParameterMirror parameterMirror = constructor.parameters[pos];
      return parameterMirror.type.reflectedType.toString();
    }

    injector.forEach((type) {
      var classMirror = reflectType(type);
      MethodMirror constructor;
      try {
        MethodMirror constructor = classMirror.declarations[classMirror.simpleName];
        if (constructor != null){
          var dependencies = new List.generate(constructor.parameters.length,
              (pos) => addDependency(pos, constructor));
          typeConstructorDependencies[type.toString()] = dependencies;
        }
      } catch (e) {
        typeConstructorDependencies['Element'] = new List();
      }
    });
    return typeConstructorDependencies;
  }
}


class MessageRouter {
  MessageRouter();

  call(message) {
    var json = JSON.decode(message.data);
    var type = json['type'];
    switch (type) {
      case 'update':
        print(json);
        break;
    }
  }
}

class WebSocketWrapper {
  bool connectPending = false;
  StreamController incomingMessageStream = new StreamController.broadcast();
  WebSocket webSocket;

  WebSocketWrapper(MessageRouter messageRouter) {
    incomingMessageStream.stream.listen(messageRouter);
    connect();
  }

  registerWebSocketStream(Stream webSocketsStream) {
    var splitStringStream = webSocketsStream.transform(UTF8.encoder)
    .transform(const LineSplitter());

    incomingMessageStream.addStream(splitStringStream);
  }

  connect() {
    webSocket  = new WebSocket('ws://${Uri.base.host}:8082/ws');
    webSocket.onOpen.first.then((req){

      incomingMessageStream.addStream(webSocket.onMessage);
      webSocket.onClose.first.then((_) {
        onDisconnected();
        print("Failed to connect to ${webSocket.url}. "
        "Reconnecting");
      });
    });
    webSocket.onError.listen((e) {
      print("Error on ${webSocket.url} -  $e. Reconnecting");
      onDisconnected();
    });
  }

  onDisconnected() {
    if(connectPending) return;
    connectPending = true;
    new Timer(new Duration(seconds: 2), connect);
  }
}
