import 'dart:async';
import 'dart:developer' as developer;
import 'package:air_bnb_clone/data/models/realm_models/posting/posting.dart';
import 'package:air_bnb_clone/data/services/realm/realm_query_builder.dart';
import 'package:air_bnb_clone/data/services/realm/realm_relationship_mapper.dart';
import 'package:realm/realm.dart';
import '../../models/realm_models/booking/booking.dart';
import '../../models/realm_models/conversation/conversation.dart';
import '../../models/realm_models/favourite_posting/favourite_posting.dart';
import '../../models/realm_models/message/message.dart';
import '../../models/realm_models/user/user.dart';

class RealmService {
  var config = Configuration.local(
    [
      User.schema,
      Posting.schema,
      Booking.schema,
      FavouritePosting.schema,
      Message.schema,
      Conversation.schema,
    ],
    schemaVersion: 3,
    shouldDeleteIfMigrationNeeded: true,
  );

  Realm? _realm;
  Realm _getRealm() => _realm ??= Realm(config);

  // ========== Create ==========
  Future<T> createFromEntity<T extends RealmObject>(T realmObject, {bool update = false}) async {
    final entityId = realmObject.dynamic.get("id") as String;
    if (entityId.isEmpty) {
      throw Exception("Entity ID cannot be empty");
    }
    final realm = _getRealm();
    return realm.write<T>(() {
      try {
        final outgoingRelationships = RealmRelationshipRegistry.getOutgoingRelationships<T>();
        for (final relationship in outgoingRelationships) {
          final relatedEntity = relationship.getReferencedEntity(realm, realmObject);

          if (relatedEntity != null) {
            realmObject.dynamic.set(relationship.relationshipProperty, relatedEntity);
          }
        }
      } catch (e) {
        developer.log('Error linking forward relationships', error: e);
        rethrow;
      }

      T? object = realm.find<T>(entityId);
      final isNew = object == null;
      print("THIS IS: $T, isNew: $isNew");
      T entity = realm.add(realmObject, update: update);

      if (isNew) {
        try {
          final incomingRelationships = RealmRelationshipRegistry.getIncomingRelationships<T>();
          for (final relationship in incomingRelationships) {
            final relatedEntities = relationship.getReferencingEntities(realm, entityId);
            for (final relatedEntity in relatedEntities) {
              relatedEntity.dynamic.set(relationship.relationshipProperty, entity);
            }
          }
        } catch (e) {
          developer.log('Error linking inverse relationships', error: e);
          rethrow;
        }
      }
      return entity;
    });
  }

  // ========== Read ==========
  Future<T?> getEntity<T extends RealmObject>(String id) async {
    final realm = _getRealm();
    return realm.find<T>(id);
  }

  Future<RealmResults<T>> getEntities<T extends RealmObject>(
    RealmQueryBuilder query,
  ) async {
    final realm = _getRealm();
    final objects = realm.query<T>(
      query.getQueryString(),
      query.getQueryValues(),
    );
    return objects;
  }

  Stream<RealmResultsChanges<T>> observeEntities<T extends RealmObject>(
    RealmQueryBuilder query,
  ) {
    final realm = _getRealm();
    var objects = realm.query<T>(
      query.getQueryString(),
      query.getQueryValues(),
    );
    return objects.changes;
  }

  // ========== Delete ==========
  void deleteEntity<T extends RealmObject>(String id) {
    final realm = _getRealm();
    realm.write(() {
      final entity = realm.find<T>(id);
      if (entity != null) {
        realm.delete(entity);
      }
    });
  }

  /// Clears every persisted object type in [config].
  ///
  /// Iterates [Realm.schema] in **reverse** order so types listed **first** in
  /// [Configuration.local] (usually “root” models) are deleted **last**, which matches
  /// typical FK direction. If you get link errors, reorder the schema list or delete
  /// in a custom order.
  Future<void> deleteAll() async {
    final r = _getRealm();

    try {
      r.write(() {
        for (final schemaObject in r.schema.toList().reversed) {
          if (schemaObject.baseType != ObjectType.realmObject) {
            continue; // embedded types are removed with their parent rows
          }
          final results = r.dynamic.all(schemaObject.name);
          if (results.isNotEmpty) {
            r.deleteMany(results);
          }
        }
      });
    } catch (e, st) {
      developer.log('Realm wipe failed', error: e, stackTrace: st);
    }
  }
}
