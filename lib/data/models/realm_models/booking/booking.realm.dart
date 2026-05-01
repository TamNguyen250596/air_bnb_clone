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
    RealmObjectBase.set(this, 'posting_id', postingId);
    RealmObjectBase.set(this, 'posting', posting);
    RealmObjectBase.set(this, 'user_id', userId);
    RealmObjectBase.set(this, 'user', user);
    RealmObjectBase.set(this, 'check_in', checkIn);
    RealmObjectBase.set(this, 'check_out', checkOut);
    RealmObjectBase.set(this, 'payment_amount', paymentAmount);
  }

  Booking._();

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
  DateTime? get checkIn =>
      RealmObjectBase.get<DateTime>(this, 'check_in') as DateTime?;
  @override
  set checkIn(DateTime? value) => RealmObjectBase.set(this, 'check_in', value);

  @override
  DateTime? get checkOut =>
      RealmObjectBase.get<DateTime>(this, 'check_out') as DateTime?;
  @override
  set checkOut(DateTime? value) =>
      RealmObjectBase.set(this, 'check_out', value);

  @override
  double? get paymentAmount =>
      RealmObjectBase.get<double>(this, 'payment_amount') as double?;
  @override
  set paymentAmount(double? value) =>
      RealmObjectBase.set(this, 'payment_amount', value);

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
      'posting_id': postingId.toEJson(),
      'posting': posting.toEJson(),
      'user_id': userId.toEJson(),
      'user': user.toEJson(),
      'check_in': checkIn.toEJson(),
      'check_out': checkOut.toEJson(),
      'payment_amount': paymentAmount.toEJson(),
    };
  }

  static EJsonValue _toEJson(Booking value) => value.toEJson();
  static Booking _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id} => Booking(
        fromEJson(id),
        postingId: fromEJson(ejson['posting_id']),
        posting: fromEJson(ejson['posting']),
        userId: fromEJson(ejson['user_id']),
        user: fromEJson(ejson['user']),
        checkIn: fromEJson(ejson['check_in']),
        checkOut: fromEJson(ejson['check_out']),
        paymentAmount: fromEJson(ejson['payment_amount']),
      ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Booking._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Booking, 'Booking', [
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
        'checkIn',
        RealmPropertyType.timestamp,
        mapTo: 'check_in',
        optional: true,
      ),
      SchemaProperty(
        'checkOut',
        RealmPropertyType.timestamp,
        mapTo: 'check_out',
        optional: true,
      ),
      SchemaProperty(
        'paymentAmount',
        RealmPropertyType.double,
        mapTo: 'payment_amount',
        optional: true,
      ),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
