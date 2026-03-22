// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class Conversation extends _Conversation
    with RealmEntity, RealmObjectBase, RealmObject {
  Conversation(
    String id, {
    Set<String> members = const {},
    String? avatar,
    String? name,
    String? lastMessage,
    DateTime? lastMessageAt,
    DateTime? createdAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set<RealmSet<String>>(
      this,
      'members',
      RealmSet<String>(members),
    );
    RealmObjectBase.set(this, 'avatar', avatar);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'lastMessage', lastMessage);
    RealmObjectBase.set(this, 'lastMessageAt', lastMessageAt);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  Conversation._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  RealmSet<String> get members =>
      RealmObjectBase.get<String>(this, 'members') as RealmSet<String>;
  @override
  set members(covariant RealmSet<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  String? get avatar => RealmObjectBase.get<String>(this, 'avatar') as String?;
  @override
  set avatar(String? value) => RealmObjectBase.set(this, 'avatar', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get lastMessage =>
      RealmObjectBase.get<String>(this, 'lastMessage') as String?;
  @override
  set lastMessage(String? value) =>
      RealmObjectBase.set(this, 'lastMessage', value);

  @override
  DateTime? get lastMessageAt =>
      RealmObjectBase.get<DateTime>(this, 'lastMessageAt') as DateTime?;
  @override
  set lastMessageAt(DateTime? value) =>
      RealmObjectBase.set(this, 'lastMessageAt', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<Conversation>> get changes =>
      RealmObjectBase.getChanges<Conversation>(this);

  @override
  Stream<RealmObjectChanges<Conversation>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<Conversation>(this, keyPaths);

  @override
  Conversation freeze() => RealmObjectBase.freezeObject<Conversation>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'members': members.toEJson(),
      'avatar': avatar.toEJson(),
      'name': name.toEJson(),
      'lastMessage': lastMessage.toEJson(),
      'lastMessageAt': lastMessageAt.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Conversation value) => value.toEJson();
  static Conversation _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id} => Conversation(
        fromEJson(id),
        members: fromEJson(ejson['members']),
        avatar: fromEJson(ejson['avatar']),
        name: fromEJson(ejson['name']),
        lastMessage: fromEJson(ejson['lastMessage']),
        lastMessageAt: fromEJson(ejson['lastMessageAt']),
        createdAt: fromEJson(ejson['createdAt']),
      ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Conversation._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      Conversation,
      'Conversation',
      [
        SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
        SchemaProperty(
          'members',
          RealmPropertyType.string,
          collectionType: RealmCollectionType.set,
        ),
        SchemaProperty('avatar', RealmPropertyType.string, optional: true),
        SchemaProperty('name', RealmPropertyType.string, optional: true),
        SchemaProperty('lastMessage', RealmPropertyType.string, optional: true),
        SchemaProperty(
          'lastMessageAt',
          RealmPropertyType.timestamp,
          optional: true,
        ),
        SchemaProperty(
          'createdAt',
          RealmPropertyType.timestamp,
          optional: true,
        ),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
