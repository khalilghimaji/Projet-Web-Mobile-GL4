// @dart=3.9
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data_any_of1.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationDataAnyOf1 extends NotificationDataAnyOf1 {
  @override
  final BuiltList<NotificationDataAnyOf1RankingsInner>? rankings;

  factory _$NotificationDataAnyOf1([
    void Function(NotificationDataAnyOf1Builder)? updates,
  ]) => (NotificationDataAnyOf1Builder()..update(updates))._build();

  _$NotificationDataAnyOf1._({this.rankings}) : super._();
  @override
  NotificationDataAnyOf1 rebuild(
    void Function(NotificationDataAnyOf1Builder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  NotificationDataAnyOf1Builder toBuilder() =>
      NotificationDataAnyOf1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationDataAnyOf1 && rankings == other.rankings;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rankings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'NotificationDataAnyOf1',
    )..add('rankings', rankings)).toString();
  }
}

class NotificationDataAnyOf1Builder
    implements Builder<NotificationDataAnyOf1, NotificationDataAnyOf1Builder> {
  _$NotificationDataAnyOf1? _$v;

  ListBuilder<NotificationDataAnyOf1RankingsInner>? _rankings;
  ListBuilder<NotificationDataAnyOf1RankingsInner> get rankings =>
      _$this._rankings ??= ListBuilder<NotificationDataAnyOf1RankingsInner>();
  set rankings(ListBuilder<NotificationDataAnyOf1RankingsInner>? rankings) =>
      _$this._rankings = rankings;

  NotificationDataAnyOf1Builder() {
    NotificationDataAnyOf1._defaults(this);
  }

  NotificationDataAnyOf1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rankings = $v.rankings?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationDataAnyOf1 other) {
    _$v = other as _$NotificationDataAnyOf1;
  }

  @override
  void update(void Function(NotificationDataAnyOf1Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationDataAnyOf1 build() => _build();

  _$NotificationDataAnyOf1 _build() {
    _$NotificationDataAnyOf1 _$result;
    try {
      _$result =
          _$v ?? _$NotificationDataAnyOf1._(rankings: _rankings?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rankings';
        _rankings?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'NotificationDataAnyOf1',
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

