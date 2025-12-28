class RealmQueryBuilder {

  int _queryNumber = 0;
  String _queryString = "";
  final List<String> _queryValues = <String>[];

  RealmQueryBuilder equal(String field, dynamic value) {
    _queryString += "$field == " "\$$_queryNumber";
    _queryValues.add(value);
    _queryNumber++;
    return this;
  }

  String getQueryString() {
    return _queryString;
  }

  List<dynamic> getQueryValues() {
    return _queryValues;
  }
}