import 'dart:developer' as developer;
import 'package:air_bnb_clone/data/models/realm_models/review/review.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_constant.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_query_builder.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_service.dart';
import 'package:air_bnb_clone/data/services/realm/realm_query_builder.dart';
import 'package:air_bnb_clone/data/services/realm/realm_service.dart';
import 'package:realm/realm.dart';
import 'package:rxdart/rxdart.dart';

abstract class ReviewRepository {
  Stream<RealmResultsChanges<Review>> observeReviewsByUserAndTarget({
    required String userId,
    required String targetType,
    required String targetId,
    int? limit,
  });

  /// All reviews for a target (e.g. listing), newest first. Optional [limit] caps sync/query size.
  Stream<RealmResultsChanges<Review>> observeReviewsForTarget({
    required String targetType,
    required String targetId,
    int? limit,
  });

  Future<Review> createReview(Map<String, dynamic> data);
}

class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl({
    required FireStoreService firestoreService,
    required RealmService realmManager,
  })  : _firestoreService = firestoreService,
        _realmManager = realmManager;

  final FireStoreService _firestoreService;
  final RealmService _realmManager;

  @override
  Stream<RealmResultsChanges<Review>> observeReviewsByUserAndTarget({
    required String userId,
    required String targetType,
    required String targetId,
    int? limit,
  }) {
    try {
      var firestoreQuery = FirestoreQueryBuilder(FirestoreCollection.review)
          .equalTo('user_id', userId)
          .equalTo('target_type', targetType)
          .equalTo('target_id', targetId)
          .orderBy('created_at', descending: true);
      final lim = limit;
      if (lim != null && lim > 0) {
        firestoreQuery = firestoreQuery.limit(lim);
      }
      _firestoreService.observeCollection<Review>(firestoreQuery);
      var realmQuery = RealmQueryBuilder()
          .equal('userId', userId)
          .equal('targetType', targetType)
          .equal('targetId', targetId)
          .sortDescending('createdAt');
      if (lim != null && lim > 0) {
        realmQuery = realmQuery.limit(lim);
      }
      final stream = _realmManager.observeEntities<Review>(realmQuery);
      return stream.doOnCancel(() {
        _firestoreService.removeCollectionListener(firestoreQuery);
      });
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  @override
  Stream<RealmResultsChanges<Review>> observeReviewsForTarget({
    required String targetType,
    required String targetId,
    int? limit,
  }) {
    try {
      var firestoreQuery = FirestoreQueryBuilder(FirestoreCollection.review)
          .equalTo('target_type', targetType)
          .equalTo('target_id', targetId)
          .orderBy('created_at', descending: true);
      final lim = limit;
      if (lim != null && lim > 0) {
        firestoreQuery = firestoreQuery.limit(lim);
      }
      _firestoreService.observeCollection<Review>(firestoreQuery);
      var realmQuery = RealmQueryBuilder()
          .equal('targetType', targetType)
          .equal('targetId', targetId)
          .sortDescending('createdAt');
      if (lim != null && lim > 0) {
        realmQuery = realmQuery.limit(lim);
      }
      final stream = _realmManager.observeEntities<Review>(realmQuery);
      return stream.doOnCancel(() {
        _firestoreService.removeCollectionListener(firestoreQuery);
      });
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  @override
  Future<Review> createReview(Map<String, dynamic> data) async {
    try {
      final id = await _firestoreService.createDoc<Review>(
        FirestoreCollection.review,
        null,
        data,
      );
      final created = await _realmManager.getEntity<Review>(id);
      if (created == null) {
        throw Exception("Failed to create review in local storage");
      }
      return created;
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }
}
