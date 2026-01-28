// @dart=2.19
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const NotificationTypeEnum _$notificationTypeEnum_CHANGE_OF_POSSESSED_GEMS =
    const NotificationTypeEnum._('CHANGE_OF_POSSESSED_GEMS');
const NotificationTypeEnum _$notificationTypeEnum_DIAMOND_UPDATE =
    const NotificationTypeEnum._('DIAMOND_UPDATE');
const NotificationTypeEnum _$notificationTypeEnum_RANKING_UPDATE =
    const NotificationTypeEnum._('RANKING_UPDATE');

NotificationTypeEnum _$notificationTypeEnumValueOf(String name) {
  switch (name) {
    case 'CHANGE_OF_POSSESSED_GEMS':
      return _$notificationTypeEnum_CHANGE_OF_POSSESSED_GEMS;
    case 'DIAMOND_UPDATE':
      return _$notificationTypeEnum_DIAMOND_UPDATE;
    case 'RANKING_UPDATE':
      return _$notificationTypeEnum_RANKING_UPDATE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<NotificationTypeEnum> _$notificationTypeEnumValues =
    BuiltSet<NotificationTypeEnum>(const <NotificationTypeEnum>[
      _$notificationTypeEnum_CHANGE_OF_POSSESSED_GEMS,
      _$notificationTypeEnum_DIAMOND_UPDATE,
      _$notificationTypeEnum_RANKING_UPDATE,
    ]);

Serializer<NotificationTypeEnum> _$notificationTypeEnumSerializer =
    _$NotificationTypeEnumSerializer();

class _$NotificationTypeEnumSerializer
    implements PrimitiveSerializer<NotificationTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CHANGE_OF_POSSESSED_GEMS': 'CHANGE_OF_POSSESSED_GEMS',
    'DIAMOND_UPDATE': 'DIAMOND_UPDATE',
    'RANKING_UPDATE': 'RANKING_UPDATE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CHANGE_OF_POSSESSED_GEMS': 'CHANGE_OF_POSSESSED_GEMS',
    'DIAMOND_UPDATE': 'DIAMOND_UPDATE',
    'RANKING_UPDATE': 'RANKING_UPDATE',
  };

  @override
  final Iterable<Type> types = const <Type>[NotificationTypeEnum];
  @override
  final String wireName = 'NotificationTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    NotificationTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  NotificationTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => NotificationTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$Notification extends Notification {
  @override
  final NotificationData? data;
  @override
  final String userId;
  @override
  final NotificationTypeEnum type;
  @override
  final String message;
  @override
  final bool read;
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final num version;

  factory _$Notification([void Function(NotificationBuilder)? updates]) =>
      (NotificationBuilder()..update(updates))._build();

  _$Notification._({
    this.data,
    required this.userId,
    required this.type,
    required this.message,
    required this.read,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  }) : super._();
  @override
  Notification rebuild(void Function(NotificationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationBuilder toBuilder() => NotificationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Notification &&
        data == other.data &&
        userId == other.userId &&
        type == other.type &&
        message == other.message &&
        read == other.read &&
        id == other.id &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, read.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Notification')
          ..add('data', data)
          ..add('userId', userId)
          ..add('type', type)
          ..add('message', message)
          ..add('read', read)
          ..add('id', id)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('version', version))
        .toString();
  }
}

class NotificationBuilder
    implements Builder<Notification, NotificationBuilder> {
  _$Notification? _$v;

  NotificationDataBuilder? _data;
  NotificationDataBuilder get data =>
      _$this._data ??= NotificationDataBuilder();
  set data(NotificationDataBuilder? data) => _$this._data = data;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  NotificationTypeEnum? _type;
  NotificationTypeEnum? get type => _$this._type;
  set type(NotificationTypeEnum? type) => _$this._type = type;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  bool? _read;
  bool? get read => _$this._read;
  set read(bool? read) => _$this._read = read;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  num? _version;
  num? get version => _$this._version;
  set version(num? version) => _$this._version = version;

  NotificationBuilder() {
    Notification._defaults(this);
  }

  NotificationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data?.toBuilder();
      _userId = $v.userId;
      _type = $v.type;
      _message = $v.message;
      _read = $v.read;
      _id = $v.id;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Notification other) {
    _$v = other as _$Notification;
  }

  @override
  void update(void Function(NotificationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Notification build() => _build();

  _$Notification _build() {
    _$Notification _$result;
    try {
      _$result =
          _$v ??
          _$Notification._(
            data: _data?.build(),
            userId: BuiltValueNullFieldError.checkNotNull(
              userId,
              r'Notification',
              'userId',
            ),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'Notification',
              'type',
            ),
            message: BuiltValueNullFieldError.checkNotNull(
              message,
              r'Notification',
              'message',
            ),
            read: BuiltValueNullFieldError.checkNotNull(
              read,
              r'Notification',
              'read',
            ),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'Notification',
              'id',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'Notification',
              'createdAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'Notification',
              'updatedAt',
            ),
            version: BuiltValueNullFieldError.checkNotNull(
              version,
              r'Notification',
              'version',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        _data?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Notification',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
