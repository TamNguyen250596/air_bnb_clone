import 'package:air_bnb_clone/data/services/firestore/firestore_service.dart';
import 'package:air_bnb_clone/data/services/realm/realm_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realm_dart/src/results.dart';
import 'package:rxdart/rxdart.dart';
import '../models/realm_models/posting/posting.dart';
import '../services/firestore/firestore_constant.dart';
import '../services/firestore/firestore_query_builder.dart';
import '../services/realm/realm_query_builder.dart';

class PostingRepository {

  // Init
  PostingRepository({
    required FireStoreService firestoreService,
    required RealmService realmManager,
  }) : _firestoreService = firestoreService,
       _realmManager = realmManager;

  // Properties
  final FireStoreService _firestoreService;
  final RealmService _realmManager;

  // Create
  Future<Posting> createPosting(Map<String, dynamic> data) async {
    try {
      final id = await _firestoreService.createDoc<Posting>(FirestoreCollection.posting, null, data);
      final createdPosting = await _realmManager.getEntity<Posting>(id);
      if (createdPosting == null) {
        throw Exception("Failed to create posting in local storage");
      }
      return createdPosting;
    } catch(e) {
      print(e);
      rethrow;
    }
  }

  // Read
  Future<RealmResults<Posting>> getPostingsForExplore(String searchTxt) async {
    try {
      Filter? filter;
      if (searchTxt.isNotEmpty) {
        filter = Filter.or(
          Filter('name', isGreaterThanOrEqualTo: searchTxt),
          Filter('name', isLessThanOrEqualTo: '$searchTxt\uf8ff'),
          Filter('address', isGreaterThanOrEqualTo: searchTxt),
          Filter('address', isLessThanOrEqualTo: '$searchTxt\uf8ff'),
          Filter('type', isGreaterThanOrEqualTo: searchTxt),
          Filter('type', isLessThanOrEqualTo: '$searchTxt\uf8ff'),
        );
      }

      final query = FirestoreQueryBuilder(FirestoreCollection.posting);
      if (filter != null) {
        query.filter(filter);
      }
      await _firestoreService.getCollection<Posting>(query);
      final realmQuery = RealmQueryBuilder();
      if (searchTxt.isNotEmpty) {
        realmQuery.orContains(['name', 'address', 'type'], searchTxt);
      }
      return await _realmManager.getEntities<Posting>(realmQuery);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<RealmResults<Posting>> getPostings(String hostId, String searchTxt) async {
    try {
      Filter? filter;
      if (searchTxt.isNotEmpty) {
        filter = Filter.or(
          //  Search by name
          Filter('name', isGreaterThanOrEqualTo: searchTxt),
          Filter('name', isLessThanOrEqualTo: '$searchTxt\uf8ff'),

          //  Search by address
          Filter('address', isGreaterThanOrEqualTo: searchTxt),
          Filter('address', isLessThanOrEqualTo: '$searchTxt\uf8ff'),

          //  Search by type
          Filter('type', isGreaterThanOrEqualTo: searchTxt),
          Filter('type', isLessThanOrEqualTo: '$searchTxt\uf8ff'),
        );
      }

      FirestoreQueryBuilder query = FirestoreQueryBuilder(FirestoreCollection.posting)
          .equalTo("host_id", hostId);
      if (filter != null) {
        query.filter(filter);
      }
      await _firestoreService.getCollection(query);
      final entities = await _realmManager.getEntities<Posting>(
          RealmQueryBuilder()
              .equal("hostId", hostId)
              .like("name", searchTxt)
              .like("address", searchTxt)
              .like("type", searchTxt)
      );
      return entities;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

   Stream<RealmResultsChanges<Posting>> observePostings(String hostId) {
    try {
      _firestoreService.observeCollection<Posting>(
          FirestoreQueryBuilder(FirestoreCollection.posting)
              .equalTo("host_id", hostId)
      );
      final localPostingStream = _realmManager.observeEntities<Posting>(
          RealmQueryBuilder()
              .equal("hostId", hostId)
      );

      localPostingStream.doOnCancel(() {
        _firestoreService.removeCollectionListener(
            FirestoreQueryBuilder(FirestoreCollection.posting)
                .equalTo("host_id", hostId)
        );
      });

      return localPostingStream;
    } catch(e) {
      print(e);
      rethrow;
    }
  }

  // Update
  Future<Posting> updatePosting(String id, Map<String, dynamic> data) async {
    try {
      await _firestoreService.updateDoc<Posting>(FirestoreCollection.posting, id, data);
      final updatedPosting = await _realmManager.getEntity<Posting>(id);
      if (updatedPosting == null) {
        throw Exception("Failed to retrieve updated posting from local storage");
      }
      return updatedPosting;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
