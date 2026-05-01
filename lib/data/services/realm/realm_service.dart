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
import '../../models/realm_models/notification/notification.dart';
import '../../models/realm_models/review/review.dart';
import '../../models/realm_models/user/user.dart';

class RealmService {
  var config = Configuration.local(
    [
      User.schema,
      Posting.schema,
      Booking.schema,
      FavouritePosting.schema,
      Message.schema,
      Review.schema,
      Conversation.schema,
      Notification.schema,
    ],
    schemaVersion: 7,
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

  // ========== Update ==========
  Future<T?> updateEntity<T extends RealmObject>(String primaryKey, Map<String, dynamic> data) async {
    final realm = _getRealm();
    return realm.write<T?>(() {
      final object = realm.find<T>(primaryKey);
      if (object == null) return null;

      for (final MapEntry<String, dynamic> entry in data.entries) {
        final prop = _schemaPropertyForKey(object.objectSchema, entry.key);
        if (prop == null) {
          developer.log('updateEntity: unknown property "${entry.key}" on $T', name: 'RealmService');
          continue;
        }
        if (prop.primaryKey) continue;

        final coerced = _coerceValueForRealmProperty(entry.value, prop.propertyType, prop.optional);
        object.dynamic.set(prop.mapTo, coerced);
      }
      return object;
    });
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

  static SchemaProperty? _schemaPropertyForKey(SchemaObject schema, String key) {
    for (final p in schema) {
      if (p.name == key || p.mapTo == key) {
        return p;
      }
    }
    return null;
  }

  /// Coerces [value] (e.g. from Firestore JSON) to a type compatible with [propertyType].
  static Object? _coerceValueForRealmProperty(
    dynamic value,
    RealmPropertyType type,
    bool optional,
  ) {
    if (value == null) {
      return null;
    }
    switch (type) {
      case RealmPropertyType.string:
        return value is String ? value : value.toString();
      case RealmPropertyType.bool:
        if (value is bool) return value;
        if (value is int) return value != 0;
        if (value is String) {
          final v = value.toLowerCase();
          if (v == 'true' || v == '1') return true;
          if (v == 'false' || v == '0') return false;
        }
        return null;
      case RealmPropertyType.int:
        if (value is int) return value;
        if (value is num) return value.toInt();
        return int.tryParse(value.toString());
      case RealmPropertyType.double:
      case RealmPropertyType.float:
        if (value is double) return value;
        if (value is num) return value.toDouble();
        return double.tryParse(value.toString());
      case RealmPropertyType.timestamp:
        if (value is DateTime) return value;
        if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
        if (value is String) return DateTime.tryParse(value);
        return null;
      case RealmPropertyType.object:
      case RealmPropertyType.mixed:
        return value;
      default:
        return value;
    }
  }
}
