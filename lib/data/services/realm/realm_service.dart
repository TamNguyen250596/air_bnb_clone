import 'package:air_bnb_clone/data/services/realm/realm_query_builder.dart';
import 'package:realm/realm.dart';
import 'package:air_bnb_clone/data/model/user.dart';

class RealmService {

  var config = Configuration.local([User.schema]);

  // ========== Create ==========
  Future<T> createFromEntity<T extends RealmObject>(T realmObject, {bool update = false}) async {
    final realm = Realm(config);
    return realm.write<T>(() {
      T entity = realm.add(realmObject, update: update);
      return entity;
    });
  }

  // ========== Read ==========
  Future<T?> getEntity<T extends RealmObject>(String id) async {
    final realm = Realm(config);
    return realm.find<T>(id);
  }

  Future<RealmResults<T>> getEntities<T extends RealmObject>(RealmQueryBuilder query) async {
    final realm = Realm(config);
    var objects = realm.query<T>(query.getQueryString(), query.getQueryValues());
    return objects;
  }

  Stream<RealmResultsChanges<T>> observeEntities<T extends RealmObject>(RealmQueryBuilder query) {
    final realm = Realm(config);
    var objects = realm.query<T>(query.getQueryString(), query.getQueryValues());
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