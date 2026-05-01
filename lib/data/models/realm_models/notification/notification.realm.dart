// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class Notification extends _Notification
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Notification(
    String id, {
    String? title,
    String? body,
    String? imageUrl,
    String? type,
    bool isRead = false,
    DateTime? createdAt,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Notification>({
        'is_read': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'body', body);
    RealmObjectBase.set(this, 'image_url', imageUrl);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'is_read', isRead);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  Notification._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get title => RealmObjectBase.get<String>(this, 'title') as String?;
  @override
  set title(String? value) => RealmObjectBase.set(this, 'title', value);

  @override
  String? get body => RealmObjectBase.get<String>(this, 'body') as String?;
  @override
  set body(String? value) => RealmObjectBase.set(this, 'body', value);

  @override
  String? get imageUrl =>
      RealmObjectBase.get<String>(this, 'image_url') as String?;
  @override
  set imageUrl(String? value) => RealmObjectBase.set(this, 'image_url', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  bool get isRead => RealmObjectBase.get<bool>(this, 'is_read') as bool;
  @override
  set isRead(bool value) => RealmObjectBase.set(this, 'is_read', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<Notification>> get changes =>
      RealmObjectBase.getChanges<Notification>(this);

  @override
  Stream<RealmObjectChanges<Notification>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<Notification>(this, keyPaths);

  @override
  Notification freeze() => RealmObjectBase.freezeObject<Notification>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'title': title.toEJson(),
      'body': body.toEJson(),
      'image_url': imageUrl.toEJson(),
      'type': type.toEJson(),
      'is_read': isRead.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Notification value) => value.toEJson();
  static Notification _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id} => Notification(
        fromEJson(id),
        title: fromEJson(ejson['title']),
        body: fromEJson(ejson['body']),
        imageUrl: fromEJson(ejson['image_url']),
        type: fromEJson(ejson['type']),
        isRead: fromEJson(ejson['is_read'], defaultValue: false),
        createdAt: fromEJson(ejson['created_at']),
      ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Notification._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      Notification,
      'Notification',
      [
        SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
        SchemaProperty('title', RealmPropertyType.string, optional: true),
        SchemaProperty('body', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'imageUrl',
          RealmPropertyType.string,
          mapTo: 'image_url',
          optional: true,
        ),
        SchemaProperty('type', RealmPropertyType.string, optional: true),
        SchemaProperty('isRead', RealmPropertyType.bool, mapTo: 'is_read'),
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
