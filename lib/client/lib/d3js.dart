library d3_js;

import 'dart:js';


class D3 {
  JsObject d3;
  JsFunction _append;
  JsFunction _attr;
  JsFunction _style;
  
  D3(this.d3) {
    _append = d3['selection']['prototype']['append'];
    _attr = d3['selection']['prototype']['attr'];
    _style = d3['selection']['prototype']['style'];
  }
  
  select(Iterable selector) => d3.callMethod('select', selector);
  
  append(Iterable selector, to) =>
    _append.apply(selector, thisArg: to);
  
  attr(attr, value, to) =>
      _attr.apply([attr, value], thisArg: to);
  
  style(attr, value, to) =>
      _style.apply([attr, value], thisArg: to);
  
  
}