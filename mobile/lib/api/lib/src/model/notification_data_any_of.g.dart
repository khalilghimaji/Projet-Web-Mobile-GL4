// @dart=2.19
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data_any_of.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationDataAnyOf extends NotificationDataAnyOf {
  @override
  final num? gain;
  @override
  final num? newDiamonds;

  factory _$NotificationDataAnyOf([
    void Function(NotificationDataAnyOfBuilder)? updates,
  ]) => (NotificationDataAnyOfBuilder()..update(updates))._build();

  _$NotificationDataAnyOf._({this.gain, this.newDiamonds}) : super._();
  @override
  NotificationDataAnyOf rebuild(
    void Function(NotificationDataAnyOfBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  NotificationDataAnyOfBuilder toBuilder() =>
      NotificationDataAnyOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationDataAnyOf &&
        gain == other.gain &&
        newDiamonds == other.newDiamonds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, gain.hashCode);
    _$hash = $jc(_$hash, newDiamonds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationDataAnyOf')
          ..add('gain', gain)
          ..add('newDiamonds', newDiamonds))
        .toString();
  }
}

class NotificationDataAnyOfBuilder
    implements Builder<NotificationDataAnyOf, NotificationDataAnyOfBuilder> {
  _$NotificationDataAnyOf? _$v;

  num? _gain;
  num? get gain => _$this._gain;
  set gain(num? gain) => _$this._gain = gain;

  num? _newDiamonds;
  num? get newDiamonds => _$this._newDiamonds;
  set newDiamonds(num? newDiamonds) => _$this._newDiamonds = newDiamonds;

  NotificationDataAnyOfBuilder() {
    NotificationDataAnyOf._defaults(this);
  }

  NotificationDataAnyOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _gain = $v.gain;
      _newDiamonds = $v.newDiamonds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationDataAnyOf other) {
    _$v = other as _$NotificationDataAnyOf;
  }

  @override
  void update(void Function(NotificationDataAnyOfBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationDataAnyOf build() => _build();

  _$NotificationDataAnyOf _build() {
    final _$result =
        _$v ?? _$NotificationDataAnyOf._(gain: gain, newDiamonds: newDiamonds);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
