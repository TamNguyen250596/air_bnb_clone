// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_posting.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class FavouritePosting extends _FavouritePosting
    with RealmEntity, RealmObjectBase, RealmObject {
  FavouritePosting(
    String id, {
    String? postingId,
    Posting? posting,
    String? userId,
    User? user,
    DateTime? createdAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'posting_id', postingId);
    RealmObjectBase.set(this, 'posting', posting);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'user', user);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  FavouritePosting._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get postingId =>
      RealmObjectBase.get<String>(this, 'posting_id') as String?;
  @override
  set postingId(String? value) =>
      RealmObjectBase.set(this, 'posting_id', value);

  @override
  Posting? get posting =>
      RealmObjectBase.get<Posting>(this, 'posting') as Posting?;
  @override
  set posting(covariant Posting? value) =>
      RealmObjectBase.set(this, 'posting', value);

  @override
  String? get userId => RealmObjectBase.get<String>(this, 'user_id') as String?;
  @override
  set userId(String? value) => RealmObjectBase.set(this, 'user_id', value);

  @override
  User? get user => RealmObjectBase.get<User>(this, 'user') as User?;
  @override
  set user(covariant User? value) => RealmObjectBase.set(this, 'user', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<FavouritePosting>> get changes =>
      RealmObjectBase.getChanges<FavouritePosting>(this);

  @override
  Stream<RealmObjectChanges<FavouritePosting>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<FavouritePosting>(this, keyPaths);

  @override
  FavouritePosting freeze() =>
      RealmObjectBase.freezeObject<FavouritePosting>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'posting_id': postingId.toEJson(),
      'posting': posting.toEJson(),
      'user_id': userId.toEJson(),
      'user': user.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(FavouritePosting value) => value.toEJson();
  static FavouritePosting _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id} => FavouritePosting(
        fromEJson(id),
        postingId: fromEJson(ejson['posting_id']),
        posting: fromEJson(ejson['posting']),
        userId: fromEJson(ejson['user_id']),
        user: fromEJson(ejson['user']),
        createdAt: fromEJson(ejson['created_at']),
      ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(FavouritePosting._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      FavouritePosting,
      'FavouritePosting',
      [
        SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
        SchemaProperty(
          'postingId',
          RealmPropertyType.string,
          mapTo: 'posting_id',
          optional: true,
        ),
        SchemaProperty(
          'posting',
          RealmPropertyType.object,
          optional: true,
          linkTarget: 'Posting',
        ),
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
          'createdAt',
          RealmPropertyType.timestamp,
          mapTo: 'created_at',
          optional: true,
        ),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
