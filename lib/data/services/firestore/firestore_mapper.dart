import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/user.dart';

class FirestoreMapper {
  static final Map<Type, Function(Map<String, dynamic>)> _factories = {
    User: (map) => User.fromFirestore(map)
  };

  static T fromMap<T>(Map<String, dynamic> map) {
    final factory = _factories[T];
    if (factory == null) {
      throw Exception("No factory registered for type $T");
    }
    if (map["id"] == null) {
      map["id"] = map["id"];
    }
    return factory(map) as T;
  }

  static T fromDocumentSnapshot<T>(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var map = snapshot.data();
    if (map == null) {
      throw Exception("Document data is null");
    }
    if (map["id"] == null) {
      map["id"] = snapshot.id;
    }
    final factory = _factories[T];
    if (factory == null) {
      throw Exception("No factory registered for type $T");
    }
    return factory(map) as T;
  }

  static final Map<Type, Map<String, dynamic> Function(dynamic)> _toFirestore = {
    User: (user) => (user as User).toFirestore(),
  };

  static Map<String, dynamic> convert<T>(T instance) {
    final encoder = _toFirestore[T];
    if (encoder == null) throw Exception("Encoder not found for $T");
    return encoder(instance);
  }
}