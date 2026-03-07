import 'dart:developer' as developer;
import 'package:air_bnb_clone/data/models/realm_models/posting/posting.dart';
import 'package:air_bnb_clone/data/services/realm/realm_query_builder.dart';
import 'package:air_bnb_clone/data/services/realm/realm_relationship_mapper.dart';
import 'package:realm/realm.dart';
import '../../models/realm_models/booking/booking.dart';
import '../../models/realm_models/conversation/conversation.dart';
import '../../models/realm_models/message/message.dart';
import '../../models/realm_models/user/user.dart';

class RealmService {
  var config = Configuration.local(
    [
      User.schema,
      Posting.schema,
      Booking.schema,
      Message.schema,
      Conversation.schema,
    ],
    schemaVersion: 2,
    shouldDeleteIfMigrationNeeded: true,
  );

  // ========== Create ==========
  Future<T> createFromEntity<T extends RealmObject>(
    T realmObject, {
    bool update = false,
  }) async {
    final entityId = realmObject.dynamic.get("id") as String;
    if (entityId.isEmpty) {
      throw Exception("Entity ID cannot be empty");
    }
    final realm = Realm(config);
    return realm.write<T>(() {
      try {
        final outgoingRelationships =
            RealmRelationshipRegistry.getOutgoingRelationships<T>();
        for (final relationship in outgoingRelationships) {
          final relatedEntity = relationship.getReferencedEntity(
            realm,
            realmObject,
          );
          realmObject.dynamic.set(
            relationship.relationshipProperty,
            relatedEntity,
          );
        }
      } catch (e) {
        developer.log('Error linking forward relationships', error: e);
        rethrow;
      }

      bool isNew = realm.find<T>(entityId) == null;
      T entity = realm.add(realmObject, update: update);

      if (isNew) {
        try {
          final incomingRelationships =
              RealmRelationshipRegistry.getIncomingRelationships<T>();
          for (final relationship in incomingRelationships) {
            final relatedEntities = relationship.getReferencingEntities(
              realm,
              entityId,
            );
            for (final relatedEntity in relatedEntities) {
              relatedEntity.dynamic.set(
                relationship.relationshipProperty,
                entity,
              );
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
    final realm = Realm(config);
    return realm.find<T>(id);
  }

  Future<RealmResults<T>> getEntities<T extends RealmObject>(
    RealmQueryBuilder query,
  ) async {
    final realm = Realm(config);
    var objects = realm.query<T>(
      query.getQueryString(),
      query.getQueryValues(),
    );
    return objects;
  }

  Stream<RealmResultsChanges<T>> observeEntities<T extends RealmObject>(
    RealmQueryBuilder query,
  ) {
    final realm = Realm(config);
    var objects = realm.query<T>(
      query.getQueryString(),
      query.getQueryValues(),
    );
    return objects.changes;
  }

  // ========== Delete ==========
  void deleteEntity<T extends RealmObject>(String id) {
    final realm = Realm(config);
    final entity = realm.find<T>(id);
    if (entity != null) {
      realm.delete(entity);
    }
  }

  void deleteAll() async {
    final realm = Realm(config);
    Realm.deleteRealm(config.path);
    realm.close();
  }
}
