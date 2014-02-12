// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library http_mock;

import 'dart:io';
import 'dart:async';
import 'package:unittest/mock.dart';


class HttpRequestMock extends Mock implements HttpRequest {
  Uri uri;
  String method;
  var data;
  HttpResponseMock response = new HttpResponseMock();

  HttpRequestMock(this.uri, {this.method});

  noSuchMethod(i) => super.noSuchMethod(i);
}

class HttpResponseMock extends Mock implements HttpResponse {
  int statusCode;
  var _onClose;

  Future close() {
    if (_onClose != null) {
      _onClose();
    }
    return new Future.value();
  }

  noSuchMethod(i) => super.noSuchMethod(i);
}
