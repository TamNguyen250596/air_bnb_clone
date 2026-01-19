import 'package:air_bnb_clone/data/services/firestore/firestore_service.dart';
import 'package:air_bnb_clone/data/services/realm/realm_service.dart';

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

}
