class Widget {
  String content;

  Widget.fromJson(Map json) {
    content = json['content'];
  }

  Map toJson() {
    return {'content' : content};
  }
}
