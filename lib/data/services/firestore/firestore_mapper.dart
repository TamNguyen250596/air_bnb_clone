import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/realm_models/booking/booking.dart';
import '../../models/realm_models/booking/booking_extensions.dart';
import '../../models/realm_models/conversation/conversation.dart';
import '../../models/realm_models/conversation/conversation_extensions.dart';
import '../../models/realm_models/message/message.dart';
import '../../models/realm_models/message/message_extensions.dart';
import '../../models/realm_models/posting/posting.dart';
import '../../models/realm_models/posting/posting_extensions.dart';
import '../../models/realm_models/user/user.dart';
import '../../models/realm_models/user/user_extensions.dart';

class FirestoreMapper {
  static final Map<Type, Function(Map<String, dynamic>)> _factories = {
    User: (map) => UserFirestoreHelper.fromFirestore(map),
    Posting: (map) => PostingFirestoreHelper.fromFirestore(map),
    Booking: (map) => BookingFirestoreHelper.fromFirestore(map),
    Message: (map) => MessageFirestoreHelper.fromFirestore(map),
    Conversation: (map) => ConversationFirestoreHelper.fromFirestore(map),
  };

  static T fromMap<T>(Map<String, dynamic> map) {
    final factory = _factories[T];
    if (factory == null) {
      throw Exception("No factory registered for type $T");
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
    Posting: (posting) => (posting as Posting).toFirestore(),
    Booking: (booking) => (booking as Booking).toFirestore(),
    Message: (message) => (message as Message).toFirestore(),
    Conversation: (conversation) =>
        (conversation as Conversation).toFirestore(),
  };

  static Map<String, dynamic> convert<T>(T instance) {
    final encoder = _toFirestore[T];
    if (encoder == null) throw Exception("Encoder not found for $T");
    return encoder(instance);
  }
}