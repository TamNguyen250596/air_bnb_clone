// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class Message extends $Message with RealmEntity, RealmObjectBase, RealmObject {
  Message(
    String id, {
    String? senderId,
    User? sender,
    String? conversationId,
    String? text,
    DateTime? createdAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'sender_id', senderId);
    RealmObjectBase.set(this, 'sender', sender);
    RealmObjectBase.set(this, 'conversation_id', conversationId);
    RealmObjectBase.set(this, 'text', text);
    RealmObjectBase.set(this, 'created_at', createdAt);
  }

  Message._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get senderId =>
      RealmObjectBase.get<String>(this, 'sender_id') as String?;
  @override
  set senderId(String? value) => RealmObjectBase.set(this, 'sender_id', value);

  @override
  User? get sender => RealmObjectBase.get<User>(this, 'sender') as User?;
  @override
  set sender(covariant User? value) =>
      RealmObjectBase.set(this, 'sender', value);

  @override
  String? get conversationId =>
      RealmObjectBase.get<String>(this, 'conversation_id') as String?;
  @override
  set conversationId(String? value) =>
      RealmObjectBase.set(this, 'conversation_id', value);

  @override
  String? get text => RealmObjectBase.get<String>(this, 'text') as String?;
  @override
  set text(String? value) => RealmObjectBase.set(this, 'text', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'created_at') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'created_at', value);

  @override
  Stream<RealmObjectChanges<Message>> get changes =>
      RealmObjectBase.getChanges<Message>(this);

  @override
  Stream<RealmObjectChanges<Message>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Message>(this, keyPaths);

  @override
  Message freeze() => RealmObjectBase.freezeObject<Message>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'sender_id': senderId.toEJson(),
      'sender': sender.toEJson(),
      'conversation_id': conversationId.toEJson(),
      'text': text.toEJson(),
      'created_at': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Message value) => value.toEJson();
  static Message _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id} => Message(
        fromEJson(id),
        senderId: fromEJson(ejson['sender_id']),
        sender: fromEJson(ejson['sender']),
        conversationId: fromEJson(ejson['conversation_id']),
        text: fromEJson(ejson['text']),
        createdAt: fromEJson(ejson['created_at']),
      ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Message._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Message, 'Message', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty(
        'senderId',
        RealmPropertyType.string,
        mapTo: 'sender_id',
        optional: true,
      ),
      SchemaProperty(
        'sender',
        RealmPropertyType.object,
        optional: true,
        linkTarget: 'User',
      ),
      SchemaProperty(
        'conversationId',
        RealmPropertyType.string,
        mapTo: 'conversation_id',
        optional: true,
      ),
      SchemaProperty('text', RealmPropertyType.string, optional: true),
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
