import 'package:realm/realm.dart';

/// Describes one foreign-key → object link pair on a Realm model (`relationKey` stores the
/// id; `relationshipProperty` is the Realm link field). Used by [RealmRelationshipRegistry].
class RealmRelationship<T extends RealmObject> {
  RealmRelationship(this.relationKey, this.relationshipProperty);

  final String relationKey;
  final String relationshipProperty;

  /// Resolves and returns the entity referenced by [sourceObject] via [relationKey].
  /// [sourceObject] is the entity that holds the foreign key (e.g. Posting `host_id`).
  T? getReferencedEntity(Realm realm, RealmObject sourceObject) {
    final id = sourceObject.dynamic.get(relationKey) as String?;
    if (id == null || id.isEmpty) return null;
    return realm.find<T>(id);
  }

  /// Returns all entities of type T that reference the given [referencedEntityId].
  RealmResults<T> getReferencingEntities(Realm realm, String referencedEntityId) {
    final query = '$relationKey == \$0 AND $relationshipProperty == \$1';
    return realm.query<T>(query, [referencedEntityId, null]);
  }
}
