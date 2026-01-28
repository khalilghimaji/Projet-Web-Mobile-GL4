// @dart=2.19
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data_any_of1_rankings_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationDataAnyOf1RankingsInner
    extends NotificationDataAnyOf1RankingsInner {
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final num? score;
  @override
  final String? imageUrl;

  factory _$NotificationDataAnyOf1RankingsInner([
    void Function(NotificationDataAnyOf1RankingsInnerBuilder)? updates,
  ]) =>
      (NotificationDataAnyOf1RankingsInnerBuilder()..update(updates))._build();

  _$NotificationDataAnyOf1RankingsInner._({
    this.firstName,
    this.lastName,
    this.score,
    this.imageUrl,
  }) : super._();
  @override
  NotificationDataAnyOf1RankingsInner rebuild(
    void Function(NotificationDataAnyOf1RankingsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  NotificationDataAnyOf1RankingsInnerBuilder toBuilder() =>
      NotificationDataAnyOf1RankingsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationDataAnyOf1RankingsInner &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        score == other.score &&
        imageUrl == other.imageUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationDataAnyOf1RankingsInner')
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('score', score)
          ..add('imageUrl', imageUrl))
        .toString();
  }
}

class NotificationDataAnyOf1RankingsInnerBuilder
    implements
        Builder<
          NotificationDataAnyOf1RankingsInner,
          NotificationDataAnyOf1RankingsInnerBuilder
        > {
  _$NotificationDataAnyOf1RankingsInner? _$v;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  num? _score;
  num? get score => _$this._score;
  set score(num? score) => _$this._score = score;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  NotificationDataAnyOf1RankingsInnerBuilder() {
    NotificationDataAnyOf1RankingsInner._defaults(this);
  }

  NotificationDataAnyOf1RankingsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _score = $v.score;
      _imageUrl = $v.imageUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationDataAnyOf1RankingsInner other) {
    _$v = other as _$NotificationDataAnyOf1RankingsInner;
  }

  @override
  void update(
    void Function(NotificationDataAnyOf1RankingsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  NotificationDataAnyOf1RankingsInner build() => _build();

  _$NotificationDataAnyOf1RankingsInner _build() {
    final _$result =
        _$v ??
        _$NotificationDataAnyOf1RankingsInner._(
          firstName: firstName,
          lastName: lastName,
          score: score,
          imageUrl: imageUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
