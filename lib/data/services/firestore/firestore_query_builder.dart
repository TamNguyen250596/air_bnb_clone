import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreQueryBuilder {

  // Init
  FirestoreQueryBuilder(this._collection);

  // Properties
  final String _collection;
  final List<(String, Object?)> _equalQueries = [];
  Filter? _filter;

  // Function
  FirestoreQueryBuilder equalTo(String field, Object value) {
    _equalQueries.add((field, value));
    return this;
  }

  FirestoreQueryBuilder filter(Filter filter) {
    _filter = filter;
    return this;
  }

  Query<Map<String, dynamic>> build(FirebaseFirestore firestore) {
    Query<Map<String, dynamic>> query = firestore.collection(_collection);

    if (_filter != null) {
      query = query.where(_filter!);
    } else {
      for (final (field, value) in _equalQueries) {
        query = query.where(field, isEqualTo: value);
      }
    }
    return query;
  }
}