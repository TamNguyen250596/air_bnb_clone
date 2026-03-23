import '../../models/realm_models/booking/booking.dart';
import '../../models/realm_models/booking/booking_extensions.dart';
import '../../models/realm_models/favourite_posting/favourite_posting.dart';
import '../../models/realm_models/favourite_posting/favourite_posting_extensions.dart';
import '../../models/realm_models/message/message.dart';
import '../../models/realm_models/message/message_extensions.dart';
import '../../models/realm_models/posting/posting.dart';
import '../../models/realm_models/posting/posting_extensions.dart';
import '../../models/realm_models/review/review.dart';
import '../../models/realm_models/review/review_extensions.dart';
import '../../models/realm_models/user/user.dart';
import '../../models/realm_models/user/user_extensions.dart';
import 'realm_relationship.dart';

export 'realm_relationship.dart';

/// Registry of Realm object relationships. Used by [RealmService.createFromEntity]
/// to resolve foreign-key IDs into linked objects and to back-fill inverse links.
///
/// ## Registry layout
///
/// Each model type that participates in linking has:
///
/// - A **`RealmRelationshipHelper`** holding **outgoing** and **incoming** lists of
///   [RealmRelationship] (id field + link field pairs).
/// - A single **`Map<Type, RealmRelationshipHelper>`** (`_helpers`) for lookup by `T`
///   at runtime via [RealmRelationshipRegistry.getOutgoingRelationships] and
///   [RealmRelationshipRegistry.getIncomingRelationships].
/// - A separate **`ModelRelationshipExtension`** on each type (same `*_extensions.dart`
///   file as `ModelFirestoreExtension`): `realmOutgoingRelationships` and
///   `realmIncomingRelationships`. The map is built from those getters—**adding a new
///   linked model** means: add/update that relationship extension, add a `_helpers` entry,
///   and update related types.
///
/// ```mermaid
/// flowchart LR
///   t[Type] --> h[RealmRelationshipHelper]
///   h --> o[outgoing]
///   h --> i[incoming]
/// ```
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
/// So [PostingRelationshipExtension.realmOutgoingRelationships] includes
/// `RealmRelationship<User>("hostId", "host")`.
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
/// So [BookingRelationshipExtension.realmOutgoingRelationships] includes both
/// `RealmRelationship<Posting>("postingId", "posting")` and
/// `RealmRelationship<User>("userId", "user")`.
///
/// ## How to use outgoing vs incoming
///
/// **Outgoing** = “This type stores IDs; we need to fill the link from the realm.”
///
/// When you create an entity and only set the *id* fields (e.g. `postingId`, `userId`),
/// the link fields (e.g. `posting`, `user`) are still null. The registry uses
/// the **outgoing** list for `T` to know which (id field, link field) pairs to resolve:
/// for each pair it looks up the entity by id in the realm and sets the link.
///
/// Example: You create a [Booking] with `postingId: "p1"`, `userId: "u1"`. The
/// registry sees [BookingRelationshipExtension.realmOutgoingRelationships], reads `postingId`
/// and `userId`, finds [Posting] "p1" and [User] "u1" in the realm, and sets
/// `booking.posting` and `booking.user`. Same idea for [Posting]: set `hostId` and
/// the registry fills `host`.
///
/// **Incoming** = “Other types point to this type; after we add this entity, back-fill their links.”
///
/// When you create an entity (e.g. a new [User] or [Posting]), there may already be
/// other entities in the realm that reference it by *id* but have a null *link*
/// (e.g. Bookings with `userId == newUser.id` but `user == null`). The registry uses
/// the **incoming** list for `T` to find those and set their link to the new entity.
///
/// Example: You add a new [User] with id `"u2"`. The registry looks at
/// [UserRelationshipExtension.realmIncomingRelationships]: Postings with `hostId == "u2"`,
/// Bookings with `userId == "u2"`, Messages with `senderId == "u2"`. For each, it sets
/// `host`, `user`, or `sender` to this new User.
///
/// Property names in [RealmRelationship] must match the Realm model field names
/// exactly (e.g. `postingId` and `posting` on [Booking]).

/// Holds [RealmRelationship] lists for both directions for one model [Type].
class RealmRelationshipHelper {
  const RealmRelationshipHelper({
    required this.outgoing,
    required this.incoming,
  });

  /// Relationships this type references (outgoing foreign keys).
  /// Each entry: (relationKey = id field, relationshipProperty = link field).
  final List<RealmRelationship> outgoing;

  /// Relationships where other types reference this type (incoming).
  final List<RealmRelationship> incoming;
}

class RealmRelationshipRegistry {
  static final Map<Type, RealmRelationshipHelper> _helpers = {
    User: RealmRelationshipHelper(
      outgoing: UserRelationshipExtension.realmOutgoingRelationships,
      incoming: UserRelationshipExtension.realmIncomingRelationships,
    ),
    Posting: RealmRelationshipHelper(
      outgoing: PostingRelationshipExtension.realmOutgoingRelationships,
      incoming: PostingRelationshipExtension.realmIncomingRelationships,
    ),
    Booking: RealmRelationshipHelper(
      outgoing: BookingRelationshipExtension.realmOutgoingRelationships,
      incoming: BookingRelationshipExtension.realmIncomingRelationships,
    ),
    FavouritePosting: RealmRelationshipHelper(
      outgoing:
          FavouritePostingRelationshipExtension.realmOutgoingRelationships,
      incoming:
          FavouritePostingRelationshipExtension.realmIncomingRelationships,
    ),
    Review: RealmRelationshipHelper(
      outgoing: ReviewRelationshipExtension.realmOutgoingRelationships,
      incoming: ReviewRelationshipExtension.realmIncomingRelationships,
    ),
    Message: RealmRelationshipHelper(
      outgoing: MessageRelationshipExtension.realmOutgoingRelationships,
      incoming: MessageRelationshipExtension.realmIncomingRelationships,
    ),
  };

  static List<RealmRelationship> getOutgoingRelationships<T>() {
    return _helpers[T]?.outgoing ?? const [];
  }

  static List<RealmRelationship> getIncomingRelationships<T>() {
    return _helpers[T]?.incoming ?? const [];
  }
}
