import 'package:rxdart/rxdart.dart';
import 'dart:async';

extension CustomDebounceExtensions<T> on Stream<T> {
  Stream<T> firstThenDebounce(Duration duration) {
    var first = true;
    return debounce((_) {
      if (first) {
        first = false;
        return TimerStream(true, Duration.zero);
      }
      return TimerStream(true, duration);
    });
  }
}