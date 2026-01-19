// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posting.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class Posting extends _Posting with RealmEntity, RealmObjectBase, RealmObject {
  Posting(
    String id, {
    String? name,
    String? type,
    double? price,
    String? description,
    String? address,
    String? city,
    String? country,
    double? rating,
    String? hostId,
    User? host,
    Iterable<String> images = const [],
    Iterable<String> amenities = const [],
    Map<String, int> beds = const {},
    Map<String, int> bathrooms = const {},
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'address', address);
    RealmObjectBase.set(this, 'city', city);
    RealmObjectBase.set(this, 'country', country);
    RealmObjectBase.set(this, 'rating', rating);
    RealmObjectBase.set(this, 'hostId', hostId);
    RealmObjectBase.set(this, 'host', host);
    RealmObjectBase.set<RealmList<String>>(
      this,
      'images',
      RealmList<String>(images),
    );
    RealmObjectBase.set<RealmList<String>>(
      this,
      'amenities',
      RealmList<String>(amenities),
    );
    RealmObjectBase.set<RealmMap<int>>(this, 'beds', RealmMap<int>(beds));
    RealmObjectBase.set<RealmMap<int>>(
      this,
      'bathrooms',
      RealmMap<int>(bathrooms),
    );
  }

  Posting._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  double? get price => RealmObjectBase.get<double>(this, 'price') as double?;
  @override
  set price(double? value) => RealmObjectBase.set(this, 'price', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String? get address =>
      RealmObjectBase.get<String>(this, 'address') as String?;
  @override
  set address(String? value) => RealmObjectBase.set(this, 'address', value);

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
  double? get rating => RealmObjectBase.get<double>(this, 'rating') as double?;
  @override
  set rating(double? value) => RealmObjectBase.set(this, 'rating', value);

  @override
  String? get hostId => RealmObjectBase.get<String>(this, 'hostId') as String?;
  @override
  set hostId(String? value) => RealmObjectBase.set(this, 'hostId', value);

  @override
  User? get host => RealmObjectBase.get<User>(this, 'host') as User?;
  @override
  set host(covariant User? value) => RealmObjectBase.set(this, 'host', value);

  @override
  RealmList<String> get images =>
      RealmObjectBase.get<String>(this, 'images') as RealmList<String>;
  @override
  set images(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String> get amenities =>
      RealmObjectBase.get<String>(this, 'amenities') as RealmList<String>;
  @override
  set amenities(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmMap<int> get beds =>
      RealmObjectBase.get<int>(this, 'beds') as RealmMap<int>;
  @override
  set beds(covariant RealmMap<int> value) => throw RealmUnsupportedSetError();

  @override
  RealmMap<int> get bathrooms =>
      RealmObjectBase.get<int>(this, 'bathrooms') as RealmMap<int>;
  @override
  set bathrooms(covariant RealmMap<int> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Posting>> get changes =>
      RealmObjectBase.getChanges<Posting>(this);

  @override
  Stream<RealmObjectChanges<Posting>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Posting>(this, keyPaths);

  @override
  Posting freeze() => RealmObjectBase.freezeObject<Posting>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'type': type.toEJson(),
      'price': price.toEJson(),
      'description': description.toEJson(),
      'address': address.toEJson(),
      'city': city.toEJson(),
      'country': country.toEJson(),
      'rating': rating.toEJson(),
      'hostId': hostId.toEJson(),
      'host': host.toEJson(),
      'images': images.toEJson(),
      'amenities': amenities.toEJson(),
      'beds': beds.toEJson(),
      'bathrooms': bathrooms.toEJson(),
    };
  }

  static EJsonValue _toEJson(Posting value) => value.toEJson();
  static Posting _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id} => Posting(
        fromEJson(id),
        name: fromEJson(ejson['name']),
        type: fromEJson(ejson['type']),
        price: fromEJson(ejson['price']),
        description: fromEJson(ejson['description']),
        address: fromEJson(ejson['address']),
        city: fromEJson(ejson['city']),
        country: fromEJson(ejson['country']),
        rating: fromEJson(ejson['rating']),
        hostId: fromEJson(ejson['hostId']),
        host: fromEJson(ejson['host']),
        images: fromEJson(ejson['images']),
        amenities: fromEJson(ejson['amenities']),
        beds: fromEJson(ejson['beds']),
        bathrooms: fromEJson(ejson['bathrooms']),
      ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Posting._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Posting, 'Posting', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('price', RealmPropertyType.double, optional: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('address', RealmPropertyType.string, optional: true),
      SchemaProperty('city', RealmPropertyType.string, optional: true),
      SchemaProperty('country', RealmPropertyType.string, optional: true),
      SchemaProperty('rating', RealmPropertyType.double, optional: true),
      SchemaProperty('hostId', RealmPropertyType.string, optional: true),
      SchemaProperty(
        'host',
        RealmPropertyType.object,
        optional: true,
        linkTarget: 'User',
      ),
      SchemaProperty(
        'images',
        RealmPropertyType.string,
        collectionType: RealmCollectionType.list,
      ),
      SchemaProperty(
        'amenities',
        RealmPropertyType.string,
        collectionType: RealmCollectionType.list,
      ),
      SchemaProperty(
        'beds',
        RealmPropertyType.int,
        collectionType: RealmCollectionType.map,
      ),
      SchemaProperty(
        'bathrooms',
        RealmPropertyType.int,
        collectionType: RealmCollectionType.map,
      ),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
