import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreQueryBuilder {

  // Init
  FirestoreQueryBuilder(this._collection);

  // Properties
  final String _collection;
  final List<(String, Object?)> _equalQueries = [];

  // Function
  FirestoreQueryBuilder equalTo(String field, Object value) {
    _equalQueries.add((field, value));
    return this;
  }

  Query<Map<String, dynamic>> build(FirebaseFirestore firestore) {
    var stream = firestore.collection(_collection);
    for (final (field, value) in _equalQueries) {
      stream.where(field, isEqualTo: value);
    }
    return stream;
  }
}