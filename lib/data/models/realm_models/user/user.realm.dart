// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class User extends $User with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  User(
    String id, {
    String? email,
    String? bio,
    String? city,
    String? country,
    String? firstName,
    String? lastName,
    String? fullName,
    String? imageUrl,
    bool? isHost,
    bool isCurrentlyHosting = false,
    double? earning,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<User>({
        'isCurrentlyHosting': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'bio', bio);
    RealmObjectBase.set(this, 'city', city);
    RealmObjectBase.set(this, 'country', country);
    RealmObjectBase.set(this, 'firstName', firstName);
    RealmObjectBase.set(this, 'lastName', lastName);
    RealmObjectBase.set(this, 'fullName', fullName);
    RealmObjectBase.set(this, 'imageUrl', imageUrl);
    RealmObjectBase.set(this, 'isHost', isHost);
    RealmObjectBase.set(this, 'isCurrentlyHosting', isCurrentlyHosting);
    RealmObjectBase.set(this, 'earning', earning);
  }

  User._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get email => RealmObjectBase.get<String>(this, 'email') as String?;
  @override
  set email(String? value) => RealmObjectBase.set(this, 'email', value);

  @override
  String? get bio => RealmObjectBase.get<String>(this, 'bio') as String?;
  @override
  set bio(String? value) => RealmObjectBase.set(this, 'bio', value);

  @override
  String? get city => RealmObjectBase.get<String>(this, 'city') as String?;
  @override
  set city(String? value) => RealmObjectBase.set(this, 'city', value);

  @override
  String? get country =>
      RealmObjectBase.get<String>(this, 'country') as String?;
  @override
  set country(String? value) => RealmObjectBase.set(this, 'country', value);

  @override
  String? get firstName =>
      RealmObjectBase.get<String>(this, 'firstName') as String?;
  @override
  set firstName(String? value) => RealmObjectBase.set(this, 'firstName', value);

  @override
  String? get lastName =>
      RealmObjectBase.get<String>(this, 'lastName') as String?;
  @override
  set lastName(String? value) => RealmObjectBase.set(this, 'lastName', value);

  @override
  String? get fullName =>
      RealmObjectBase.get<String>(this, 'fullName') as String?;
  @override
  set fullName(String? value) => RealmObjectBase.set(this, 'fullName', value);

  @override
  String? get imageUrl =>
      RealmObjectBase.get<String>(this, 'imageUrl') as String?;
  @override
  set imageUrl(String? value) => RealmObjectBase.set(this, 'imageUrl', value);

  @override
  bool? get isHost => RealmObjectBase.get<bool>(this, 'isHost') as bool?;
  @override
  set isHost(bool? value) => RealmObjectBase.set(this, 'isHost', value);

  @override
  bool get isCurrentlyHosting =>
      RealmObjectBase.get<bool>(this, 'isCurrentlyHosting') as bool;
  @override
  set isCurrentlyHosting(bool value) =>
      RealmObjectBase.set(this, 'isCurrentlyHosting', value);

  @override
  double? get earning =>
      RealmObjectBase.get<double>(this, 'earning') as double?;
  @override
  set earning(double? value) => RealmObjectBase.set(this, 'earning', value);

  @override
  Stream<RealmObjectChanges<User>> get changes =>
      RealmObjectBase.getChanges<User>(this);

  @override
  Stream<RealmObjectChanges<User>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<User>(this, keyPaths);

  @override
  User freeze() => RealmObjectBase.freezeObject<User>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'email': email.toEJson(),
      'bio': bio.toEJson(),
      'city': city.toEJson(),
      'country': country.toEJson(),
      'firstName': firstName.toEJson(),
      'lastName': lastName.toEJson(),
      'fullName': fullName.toEJson(),
      'imageUrl': imageUrl.toEJson(),
      'isHost': isHost.toEJson(),
      'isCurrentlyHosting': isCurrentlyHosting.toEJson(),
      'earning': earning.toEJson(),
    };
  }

  static EJsonValue _toEJson(User value) => value.toEJson();
  static User _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id} => User(
        fromEJson(id),
        email: fromEJson(ejson['email']),
        bio: fromEJson(ejson['bio']),
        city: fromEJson(ejson['city']),
        country: fromEJson(ejson['country']),
        firstName: fromEJson(ejson['firstName']),
        lastName: fromEJson(ejson['lastName']),
        fullName: fromEJson(ejson['fullName']),
        imageUrl: fromEJson(ejson['imageUrl']),
        isHost: fromEJson(ejson['isHost']),
        isCurrentlyHosting: fromEJson(
          ejson['isCurrentlyHosting'],
          defaultValue: false,
        ),
        earning: fromEJson(ejson['earning']),
      ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(User._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, User, 'User', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('email', RealmPropertyType.string, optional: true),
      SchemaProperty('bio', RealmPropertyType.string, optional: true),
      SchemaProperty('city', RealmPropertyType.string, optional: true),
      SchemaProperty('country', RealmPropertyType.string, optional: true),
      SchemaProperty('firstName', RealmPropertyType.string, optional: true),
      SchemaProperty('lastName', RealmPropertyType.string, optional: true),
      SchemaProperty('fullName', RealmPropertyType.string, optional: true),
      SchemaProperty('imageUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('isHost', RealmPropertyType.bool, optional: true),
      SchemaProperty('isCurrentlyHosting', RealmPropertyType.bool),
      SchemaProperty('earning', RealmPropertyType.double, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
