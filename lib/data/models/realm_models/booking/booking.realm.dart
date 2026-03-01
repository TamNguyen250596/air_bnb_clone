// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class Booking extends _Booking with RealmEntity, RealmObjectBase, RealmObject {
  Booking(
    String id, {
    String? postingId,
    Posting? posting,
    String? userId,
    User? user,
    DateTime? checkIn,
    DateTime? checkOut,
    double? paymentAmount,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'postingId', postingId);
    RealmObjectBase.set(this, 'posting', posting);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'user', user);
    RealmObjectBase.set(this, 'checkIn', checkIn);
    RealmObjectBase.set(this, 'checkOut', checkOut);
    RealmObjectBase.set(this, 'paymentAmount', paymentAmount);
  }

  Booking._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get postingId =>
      RealmObjectBase.get<String>(this, 'postingId') as String?;
  @override
  set postingId(String? value) => RealmObjectBase.set(this, 'postingId', value);

  @override
  Posting? get posting =>
      RealmObjectBase.get<Posting>(this, 'posting') as Posting?;
  @override
  set posting(covariant Posting? value) =>
      RealmObjectBase.set(this, 'posting', value);

  @override
  String? get userId => RealmObjectBase.get<String>(this, 'userId') as String?;
  @override
  set userId(String? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  User? get user => RealmObjectBase.get<User>(this, 'user') as User?;
  @override
  set user(covariant User? value) => RealmObjectBase.set(this, 'user', value);

  @override
  DateTime? get checkIn =>
      RealmObjectBase.get<DateTime>(this, 'checkIn') as DateTime?;
  @override
  set checkIn(DateTime? value) => RealmObjectBase.set(this, 'checkIn', value);

  @override
  DateTime? get checkOut =>
      RealmObjectBase.get<DateTime>(this, 'checkOut') as DateTime?;
  @override
  set checkOut(DateTime? value) => RealmObjectBase.set(this, 'checkOut', value);

  @override
  double? get paymentAmount =>
      RealmObjectBase.get<double>(this, 'paymentAmount') as double?;
  @override
  set paymentAmount(double? value) =>
      RealmObjectBase.set(this, 'paymentAmount', value);

  @override
  Stream<RealmObjectChanges<Booking>> get changes =>
      RealmObjectBase.getChanges<Booking>(this);

  @override
  Stream<RealmObjectChanges<Booking>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Booking>(this, keyPaths);

  @override
  Booking freeze() => RealmObjectBase.freezeObject<Booking>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'postingId': postingId.toEJson(),
      'posting': posting.toEJson(),
      'userId': userId.toEJson(),
      'user': user.toEJson(),
      'checkIn': checkIn.toEJson(),
      'checkOut': checkOut.toEJson(),
      'paymentAmount': paymentAmount.toEJson(),
    };
  }

  static EJsonValue _toEJson(Booking value) => value.toEJson();
  static Booking _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id} => Booking(
        fromEJson(id),
        postingId: fromEJson(ejson['postingId']),
        posting: fromEJson(ejson['posting']),
        userId: fromEJson(ejson['userId']),
        user: fromEJson(ejson['user']),
        checkIn: fromEJson(ejson['checkIn']),
        checkOut: fromEJson(ejson['checkOut']),
        paymentAmount: fromEJson(ejson['paymentAmount']),
      ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Booking._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Booking, 'Booking', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('postingId', RealmPropertyType.string, optional: true),
      SchemaProperty(
        'posting',
        RealmPropertyType.object,
        optional: true,
        linkTarget: 'Posting',
      ),
      SchemaProperty('userId', RealmPropertyType.string, optional: true),
      SchemaProperty(
        'user',
        RealmPropertyType.object,
        optional: true,
        linkTarget: 'User',
      ),
      SchemaProperty('checkIn', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('checkOut', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('paymentAmount', RealmPropertyType.double, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
