import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {

  Future<void> createDoc(String collection, String id, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.doc("$collection/$id").set(data);
  }

  Future<DocumentSnapshot> getDoc(String collection, String id) async {
    return await FirebaseFirestore.instance.doc("$collection/$id").get();
  }
}