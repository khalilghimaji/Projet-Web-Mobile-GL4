// @dart=3.9
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationData extends NotificationData {
  @override
  final AnyOf anyOf;

  factory _$NotificationData([
    void Function(NotificationDataBuilder)? updates,
  ]) => (NotificationDataBuilder()..update(updates))._build();

  _$NotificationData._({required this.anyOf}) : super._();
  @override
  NotificationData rebuild(void Function(NotificationDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationDataBuilder toBuilder() =>
      NotificationDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationData && anyOf == other.anyOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, anyOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'NotificationData',
    )..add('anyOf', anyOf)).toString();
  }
}

class NotificationDataBuilder
    implements Builder<NotificationData, NotificationDataBuilder> {
  _$NotificationData? _$v;

  AnyOf? _anyOf;
  AnyOf? get anyOf => _$this._anyOf;
  set anyOf(AnyOf? anyOf) => _$this._anyOf = anyOf;

  NotificationDataBuilder() {
    NotificationData._defaults(this);
  }

  NotificationDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _anyOf = $v.anyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationData other) {
    _$v = other as _$NotificationData;
  }

  @override
  void update(void Function(NotificationDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationData build() => _build();

  _$NotificationData _build() {
    final _$result =
        _$v ??
        _$NotificationData._(
          anyOf: BuiltValueNullFieldError.checkNotNull(
            anyOf,
            r'NotificationData',
            'anyOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

