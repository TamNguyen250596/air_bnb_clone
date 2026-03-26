class RealmQueryBuilder {

  int _queryNumber = 0;
  String _queryString = "";
  final List<dynamic> _queryValues = <dynamic>[];
  int? _limit;

  RealmQueryBuilder equal(String field, dynamic value) {
    if (_queryNumber > 0) {
      _queryString += " AND ";
    }
    _queryString += "$field == " "\$$_queryNumber";
    _queryValues.add(value);
    _queryNumber++;
    return this;
  }

  RealmQueryBuilder like(String field, String value) {
    if (_queryNumber > 0) {
      _queryString += " AND ";
    }
    _queryString += "$field LIKE " "\$$_queryNumber";
    _queryValues.add(value);
    _queryNumber++;
    return this;
  }

  RealmQueryBuilder greaterThanOrEqualTo(String field, dynamic value) {
    if (_queryNumber > 0) {
      _queryString += " AND ";
    }
    _queryString += "$field >= \$$_queryNumber";
    _queryValues.add(value);
    _queryNumber++;
    return this;
  }

  RealmQueryBuilder lessThan(String field, dynamic value) {
    if (_queryNumber > 0) {
      _queryString += " AND ";
    }
    _queryString += "$field < \$$_queryNumber";
    _queryValues.add(value);
    _queryNumber++;
    return this;
  }

  /// Query collection/set field containing a value (e.g. members CONTAINS userId)
  RealmQueryBuilder contains(String field, dynamic value) {
    if (_queryNumber > 0) {
      _queryString += " AND ";
    }
    _queryString += "$field CONTAINS \$$_queryNumber";
    _queryValues.add(value);
    _queryNumber++;
    return this;
  }

  /// Searches across multiple fields with OR logic (e.g. name OR address OR type)
  RealmQueryBuilder orContains(List<String> fields, String value) {
    if (value.isEmpty) return this;
    if (_queryNumber > 0) {
      _queryString += " AND ";
    }
    final paramIndex = _queryNumber++;
    final parts = fields.map((f) => "$f CONTAINS[c] \$$paramIndex").join(" OR ");
    _queryString += "($parts)";
    _queryValues.add(value);
    return this;
  }

  /// Appends Realm `SORT(field ASC)`. Call after filter clauses (e.g. [equal]).
  RealmQueryBuilder sortAscending(String field) {
    if (_queryString.isEmpty) {
      _queryString = 'TRUEPREDICATE SORT($field ASC)';
    } else {
      _queryString += ' SORT($field ASC)';
    }
    return this;
  }

  /// Appends Realm `SORT(field DESC)`. Call after filter clauses (e.g. [equal]).
  RealmQueryBuilder sortDescending(String field) {
    if (_queryString.isEmpty) {
      _queryString = 'TRUEPREDICATE SORT($field DESC)';
    } else {
      _queryString += ' SORT($field DESC)';
    }
    return this;
  }

  /// Appends Realm `LIMIT(n)`. Call after filters and sort.
  RealmQueryBuilder limit(int maxResults) {
    _limit = maxResults;
    return this;
  }

  String getQueryString() {
    var s = _queryString.isEmpty ? "TRUEPREDICATE" : _queryString;
    final lim = _limit;
    if (lim != null && lim > 0) {
      s += ' LIMIT($lim)';
    }
    return s;
  }

  List<dynamic> getQueryValues() {
    return _queryValues;
  }
}