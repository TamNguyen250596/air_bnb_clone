import 'package:realm/realm.dart';

import '../../models/realm_models/posting/posting.dart';
import '../../models/realm_models/user/user.dart';


/// Registry for inverse relationships in Realm
/// Maps entity types to their inverse relationships (objects that reference them)
class RealmInverseRelationshipRegistry {
  static final Map<Type, List<InverseRelationship>> _relationships = {
    User: [
      InverseRelationship<Posting>("hostId", "host"),
    ],
  };

  /// Get inverse relationships for a given entity type
  /// Returns empty list if no relationships are registered (doesn't throw)
  static List<InverseRelationship> getInverseRelationships<T>() {
    final list = _relationships[T];
    return list ?? [];
  }
}

/// Defines an inverse relationship configuration
/// When an entity of type T is created, this specifies:
/// - relatedKey: The foreign key field in the related entity (e.g., "hostId")
/// - propertyName: The relationship property in the related entity (e.g., "host")
class InverseRelationship<T extends RealmObject> {
  InverseRelationship(this.foreignKeyField, this.relationshipProperty);

  /// The foreign key field name in the related entity (e.g., "hostId")
  final String foreignKeyField;
  
  /// The relationship property name in the related entity (e.g., "host")
  final String relationshipProperty;
}