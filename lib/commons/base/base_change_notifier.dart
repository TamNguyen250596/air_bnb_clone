import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class BaseChangeNotifier extends ChangeNotifier {

  // ========== Life cycle ==========
  @override
  void dispose() {
    subscriptions.clear();
    super.dispose();
  }

  // ========== Properties ==========
  late CompositeSubscription subscriptions;
}