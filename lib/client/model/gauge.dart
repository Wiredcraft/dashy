part of widgets;


class Gauge extends Widget {
  int _maxValue;
  int _minValue;
  int currentValue;
  
  Gauge();
  
  set value(int value) => currentValue = value;
}
