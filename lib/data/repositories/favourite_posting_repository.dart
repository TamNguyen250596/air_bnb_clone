import 'dart:developer' as developer;
import 'package:air_bnb_clone/data/models/realm_models/favourite_posting/favourite_posting.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_constant.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_query_builder.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_service.dart';
import 'package:air_bnb_clone/data/services/realm/realm_query_builder.dart';
import 'package:air_bnb_clone/data/services/realm/realm_service.dart';
import 'package:realm/realm.dart';
import 'package:rxdart/rxdart.dart';

/// Abstract contract for favourite postings. Use [FavouritePostingRepositoryImpl] in app.
abstract class FavouritePostingRepository {
  Future<FavouritePosting> createFavouritePosting(Map<String, dynamic> data);
  Stream<RealmResultsChanges<FavouritePosting>> observeFavouritePostings(String userId);
  Future<FavouritePosting?> getFavouritePosting(String userId, String postingId);
  Future<void> deleteFavouritePosting(String id);
}

class FavouritePostingRepositoryImpl implements FavouritePostingRepository {
  FavouritePostingRepositoryImpl({
    required FireStoreService firestoreService,
    required RealmService realmManager,
  })  : _firestoreService = firestoreService,
        _realmManager = realmManager;

  final FireStoreService _firestoreService;
  final RealmService _realmManager;

  @override
  Future<FavouritePosting> createFavouritePosting(
    Map<String, dynamic> data,
  ) async {
    try {
      final id = await _firestoreService.createDoc<FavouritePosting>(
        FirestoreCollection.favouritePosting,
        null,
        data,
      );
      final created = await _realmManager.getEntity<FavouritePosting>(id);
      if (created == null) {
        throw Exception("Failed to create favourite posting in local storage");
      }
      return created;
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  @override
  Stream<RealmResultsChanges<FavouritePosting>> observeFavouritePostings(
    String userId,
  ) {
    try {
      final firestoreQuery = FirestoreQueryBuilder(
        FirestoreCollection.favouritePosting,
      ).equalTo('user_id', userId);
      _firestoreService.observeCollection<FavouritePosting>(firestoreQuery);
      final realmQuery = RealmQueryBuilder().equal('userId', userId);
      final stream =
          _realmManager.observeEntities<FavouritePosting>(realmQuery);
      return stream.doOnCancel(() {
        _firestoreService.removeCollectionListener(firestoreQuery);
      });
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  @override
  Future<FavouritePosting?> getFavouritePosting(
    String userId,
    String postingId,
  ) async {
    try {
      final query = FirestoreQueryBuilder(FirestoreCollection.favouritePosting)
          .equalTo('user_id', userId)
          .equalTo('posting_id', postingId);
      await _firestoreService.getCollection<FavouritePosting>(query);
      final realmQuery = RealmQueryBuilder()
          .equal('userId', userId)
          .equal('postingId', postingId);
      final results =
          await _realmManager.getEntities<FavouritePosting>(realmQuery);
      if (results.isEmpty) {
        return null;
      }
      return results.first;
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  @override
  Future<void> deleteFavouritePosting(String id) async {
    try {
      await _firestoreService.deleteDoc<FavouritePosting>(
        FirestoreCollection.favouritePosting,
        id,
      );
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }
}
