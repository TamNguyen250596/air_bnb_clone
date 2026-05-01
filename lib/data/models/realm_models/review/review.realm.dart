// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class Review extends _Review with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Review(
    String id, {
    double rating = 0.0,
    String? comment,
    String? userId,
    User? user,
    String? targetType,
    String? targetId,
    DateTime? createdAt,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Review>({'rating': 0.0});
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'rating', rating);
    RealmObjectBase.set(this, 'comment', comment);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'user', user);
    RealmObjectBase.set(this, 'target_type', targetType);
    RealmObjectBase.set(this, 'target_id', targetId);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  Review._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  double get rating => RealmObjectBase.get<double>(this, 'rating') as double;
  @override
  set rating(double value) => RealmObjectBase.set(this, 'rating', value);

  @override
  String? get comment =>
      RealmObjectBase.get<String>(this, 'comment') as String?;
  @override
  set comment(String? value) => RealmObjectBase.set(this, 'comment', value);

  @override
  String? get userId => RealmObjectBase.get<String>(this, 'user_id') as String?;
  @override
  set userId(String? value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  User? get user => RealmObjectBase.get<User>(this, 'user') as User?;
  @override
  set user(covariant User? value) => RealmObjectBase.set(this, 'user', value);

  @override
  String? get targetType =>
      RealmObjectBase.get<String>(this, 'target_type') as String?;
  @override
  set targetType(String? value) =>
      RealmObjectBase.set(this, 'target_type', value);

  @override
  String? get targetId =>
      RealmObjectBase.get<String>(this, 'target_id') as String?;
  @override
  set targetId(String? value) => RealmObjectBase.set(this, 'target_id', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<Review>> get changes =>
      RealmObjectBase.getChanges<Review>(this);

  @override
  Stream<RealmObjectChanges<Review>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Review>(this, keyPaths);

  @override
  Review freeze() => RealmObjectBase.freezeObject<Review>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'rating': rating.toEJson(),
      'comment': comment.toEJson(),
      'user_id': userId.toEJson(),
      'user': user.toEJson(),
      'target_type': targetType.toEJson(),
      'target_id': targetId.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Review value) => value.toEJson();
  static Review _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id} => Review(
        fromEJson(id),
        rating: fromEJson(ejson['rating'], defaultValue: 0.0),
        comment: fromEJson(ejson['comment']),
        userId: fromEJson(ejson['user_id']),
        user: fromEJson(ejson['user']),
        targetType: fromEJson(ejson['target_type']),
        targetId: fromEJson(ejson['target_id']),
        createdAt: fromEJson(ejson['created_at']),
      ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Review._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Review, 'Review', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('rating', RealmPropertyType.double),
      SchemaProperty('comment', RealmPropertyType.string, optional: true),
      SchemaProperty(
        'userId',
        RealmPropertyType.string,
        mapTo: 'user_id',
        optional: true,
      ),
      SchemaProperty(
        'user',
        RealmPropertyType.object,
        optional: true,
        linkTarget: 'User',
      ),
      SchemaProperty(
        'targetType',
        RealmPropertyType.string,
        mapTo: 'target_type',
        optional: true,
      ),
      SchemaProperty(
        'targetId',
        RealmPropertyType.string,
        mapTo: 'target_id',
        optional: true,
      ),
      SchemaProperty(
        'createdAt',
        RealmPropertyType.timestamp,
        mapTo: 'created_at',
        optional: true,
      ),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
