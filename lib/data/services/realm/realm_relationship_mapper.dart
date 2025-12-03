import 'package:realm/realm.dart';
import '../../models/realm_models/posting/posting.dart';
import '../../models/realm_models/user/user.dart';

class RealmRelationshipRegistry {

  /// Per-type: relationships this type references (outgoing foreign keys).
  static final Map<Type, List<RealmRelationship>> _outgoingRelationships = {
    Posting: [
      RealmRelationship<User>("hostId", "host"),
    ],
  };

  /// Per-type: relationships that reference this type (incoming from other types).
  static final Map<Type, List<RealmRelationship>> _incomingRelationships = {
    User: [
      RealmRelationship<Posting>("hostId", "host"),
    ],
  };

  static List<RealmRelationship> getOutgoingRelationships<T>() {
    final list = _outgoingRelationships[T];
    return list ?? [];
  }

  static List<RealmRelationship> getIncomingRelationships<T>() {
    final list = _incomingRelationships[T];
    return list ?? [];
  }
}

class RealmRelationship<T extends RealmObject> {

  RealmRelationship(this.relationKey, this.relationshipProperty);

  final String relationKey;
  final String relationshipProperty;

  /// Resolves and returns the entity referenced by [sourceObject] via [relationKey].
  /// [sourceObject] is the entity that holds the foreign key (e.g. Posting with hostId).
  T? getReferencedEntity(Realm realm, RealmObject sourceObject) {
    final id = sourceObject.dynamic.get(relationKey) as String;
    return realm.find<T>(id);
  }

  /// Returns all entities of type T that reference the given [referencedEntityId].
  RealmResults<T> getReferencingEntities(Realm realm, String referencedEntityId) {
    final query = "$relationKey == \$0 AND $relationshipProperty == \$1";
    return realm.query<T>(query, [referencedEntityId, null]);
  }
}