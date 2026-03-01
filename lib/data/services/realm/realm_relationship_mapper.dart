import 'package:realm/realm.dart';
import '../../models/realm_models/booking/booking.dart';
import '../../models/realm_models/posting/posting.dart';
import '../../models/realm_models/user/user.dart';

/// Registry of Realm object relationships. Used by [RealmService.createFromEntity]
/// to resolve foreign-key IDs into linked objects and to back-fill inverse links.
///
/// ## Model examples (this codebase)
///
/// **User** – no outgoing links; others point to User.
/// ```dart
/// class User { String id; String? email; ... }  // no hostId / userId
/// ```
///
/// **Posting** – references one User (host).
/// ```dart
/// class Posting {
///   String id;
///   String? hostId;   // ← relationKey: stored id of User
///   User? host;       // ← relationshipProperty: Realm link
///   ...
/// }
/// ```
/// So: _outgoingRelationships[Posting] = [ RealmRelationship<User>("hostId", "host") ].
///
/// **Booking** – references one Posting and one User.
/// ```dart
/// class Booking {
///   String id;
///   String? postingId;   // ← relationKey
///   Posting? posting;    // ← relationshipProperty
///   String? userId;      // ← relationKey
///   User? user;          // ← relationshipProperty
///   DateTime? checkIn;
///   DateTime? checkOut;
/// }
/// ```
/// So: _outgoingRelationships[Booking] = [
///   RealmRelationship<Posting>("postingId", "posting"),
///   RealmRelationship<User>("userId", "user"),
/// ].
///
/// ## How to use outgoing vs incoming
///
/// **Outgoing** = “This type stores IDs; we need to fill the link from the realm.”
///
/// When you create an entity and only set the *id* fields (e.g. `postingId`, `userId`),
/// the link fields (e.g. `posting`, `user`) are still null. The registry uses
/// [_outgoingRelationships] to know which (id field, link field) pairs to resolve:
/// for each pair it looks up the entity by id in the realm and sets the link.
///
/// Example: You create a [Booking] with `postingId: "p1"`, `userId: "u1"`. The
/// registry sees Booking’s outgoing list, reads `postingId` and `userId`, finds
/// [Posting] "p1" and [User] "u1" in the realm, and sets `booking.posting` and
/// `booking.user`. Same idea for [Posting]: set `hostId` and the registry fills `host`.
///
/// **Incoming** = “Other types point to this type; after we add this entity, back-fill their links.”
///
/// When you create an entity (e.g. a new [User] or [Posting]), there may already be
/// other entities in the realm that reference it by *id* but have a null *link*
/// (e.g. Bookings with `userId == newUser.id` but `user == null`). The registry
/// uses [_incomingRelationships] to find those and set their link to the new entity.
///
/// Example: You add a new [User] with id `"u2"`. The registry looks at
/// _incomingRelationships[User]: Postings with `hostId == "u2"` and Bookings with
/// `userId == "u2"`. For each, it sets `host` or `user` to this new User. So
/// existing rows that pointed to "u2" by id now point by link as well.
///
/// Property names in [RealmRelationship] must match the Realm model field names
/// exactly (e.g. `postingId` and `posting` on [Booking]).
class RealmRelationshipRegistry {

  /// Per-type: relationships this type references (outgoing foreign keys).
  /// Each entry: (relationKey = id field, relationshipProperty = link field).
  static final Map<Type, List<RealmRelationship>> _outgoingRelationships = {
    Posting: [
      RealmRelationship<User>("hostId", "host"),
    ],
    Booking: [
      RealmRelationship<Posting>("postingId", "posting"),
      RealmRelationship<User>("userId", "user"),
    ],
  };

  /// Per-type: relationships that reference this type (incoming from other types).
  /// E.g. User is referenced by Posting.hostId→host and Booking.userId→user.
  static final Map<Type, List<RealmRelationship>> _incomingRelationships = {
    User: [
      RealmRelationship<Posting>("hostId", "host"),
      RealmRelationship<Booking>("userId", "user"),
    ],
    Posting: [
      RealmRelationship<Booking>("postingId", "posting"),
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
    final id = sourceObject.dynamic.get(relationKey) as String?;
    if (id == null || id.isEmpty) return null;
    return realm.find<T>(id);
  }

  /// Returns all entities of type T that reference the given [referencedEntityId].
  RealmResults<T> getReferencingEntities(Realm realm, String referencedEntityId) {
    final query = "$relationKey == \$0 AND $relationshipProperty == \$1";
    return realm.query<T>(query, [referencedEntityId, null]);
  }
}