// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_notification_models.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DiamondUpdateData extends DiamondUpdateData {
  @override
  final num? gain;
  @override
  final num? newDiamonds;

  factory _$DiamondUpdateData([
    void Function(DiamondUpdateDataBuilder)? updates,
  ]) => (DiamondUpdateDataBuilder()..update(updates))._build();

  _$DiamondUpdateData._({this.gain, this.newDiamonds}) : super._();
  @override
  DiamondUpdateData rebuild(void Function(DiamondUpdateDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DiamondUpdateDataBuilder toBuilder() =>
      DiamondUpdateDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DiamondUpdateData &&
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
    return (newBuiltValueToStringHelper(r'DiamondUpdateData')
          ..add('gain', gain)
          ..add('newDiamonds', newDiamonds))
        .toString();
  }
}

class DiamondUpdateDataBuilder
    implements Builder<DiamondUpdateData, DiamondUpdateDataBuilder> {
  _$DiamondUpdateData? _$v;

  num? _gain;
  num? get gain => _$this._gain;
  set gain(num? gain) => _$this._gain = gain;

  num? _newDiamonds;
  num? get newDiamonds => _$this._newDiamonds;
  set newDiamonds(num? newDiamonds) => _$this._newDiamonds = newDiamonds;

  DiamondUpdateDataBuilder();

  DiamondUpdateDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _gain = $v.gain;
      _newDiamonds = $v.newDiamonds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DiamondUpdateData other) {
    _$v = other as _$DiamondUpdateData;
  }

  @override
  void update(void Function(DiamondUpdateDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DiamondUpdateData build() => _build();

  _$DiamondUpdateData _build() {
    final _$result =
        _$v ?? _$DiamondUpdateData._(gain: gain, newDiamonds: newDiamonds);
    replace(_$result);
    return _$result;
  }
}

class _$RankingUpdateData extends RankingUpdateData {
  @override
  final BuiltList<RankingEntry>? rankings;

  factory _$RankingUpdateData([
    void Function(RankingUpdateDataBuilder)? updates,
  ]) => (RankingUpdateDataBuilder()..update(updates))._build();

  _$RankingUpdateData._({this.rankings}) : super._();
  @override
  RankingUpdateData rebuild(void Function(RankingUpdateDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RankingUpdateDataBuilder toBuilder() =>
      RankingUpdateDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RankingUpdateData && rankings == other.rankings;
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
      r'RankingUpdateData',
    )..add('rankings', rankings)).toString();
  }
}

class RankingUpdateDataBuilder
    implements Builder<RankingUpdateData, RankingUpdateDataBuilder> {
  _$RankingUpdateData? _$v;

  ListBuilder<RankingEntry>? _rankings;
  ListBuilder<RankingEntry> get rankings =>
      _$this._rankings ??= ListBuilder<RankingEntry>();
  set rankings(ListBuilder<RankingEntry>? rankings) =>
      _$this._rankings = rankings;

  RankingUpdateDataBuilder();

  RankingUpdateDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rankings = $v.rankings?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RankingUpdateData other) {
    _$v = other as _$RankingUpdateData;
  }

  @override
  void update(void Function(RankingUpdateDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RankingUpdateData build() => _build();

  _$RankingUpdateData _build() {
    _$RankingUpdateData _$result;
    try {
      _$result = _$v ?? _$RankingUpdateData._(rankings: _rankings?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rankings';
        _rankings?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'RankingUpdateData',
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

class _$RankingEntry extends RankingEntry {
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final num? score;
  @override
  final String? imageUrl;

  factory _$RankingEntry([void Function(RankingEntryBuilder)? updates]) =>
      (RankingEntryBuilder()..update(updates))._build();

  _$RankingEntry._({this.firstName, this.lastName, this.score, this.imageUrl})
    : super._();
  @override
  RankingEntry rebuild(void Function(RankingEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RankingEntryBuilder toBuilder() => RankingEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RankingEntry &&
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
    return (newBuiltValueToStringHelper(r'RankingEntry')
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('score', score)
          ..add('imageUrl', imageUrl))
        .toString();
  }
}

class RankingEntryBuilder
    implements Builder<RankingEntry, RankingEntryBuilder> {
  _$RankingEntry? _$v;

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

  RankingEntryBuilder();

  RankingEntryBuilder get _$this {
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
  void replace(RankingEntry other) {
    _$v = other as _$RankingEntry;
  }

  @override
  void update(void Function(RankingEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RankingEntry build() => _build();

  _$RankingEntry _build() {
    final _$result =
        _$v ??
        _$RankingEntry._(
          firstName: firstName,
          lastName: lastName,
          score: score,
          imageUrl: imageUrl,
        );
    replace(_$result);
    return _$result;
  }
}

class _$NotificationDataUnion extends NotificationDataUnion {
  @override
  final num? gain;
  @override
  final num? newDiamonds;
  @override
  final BuiltList<RankingEntry>? rankings;

  factory _$NotificationDataUnion([
    void Function(NotificationDataUnionBuilder)? updates,
  ]) => (NotificationDataUnionBuilder()..update(updates))._build();

  _$NotificationDataUnion._({this.gain, this.newDiamonds, this.rankings})
    : super._();
  @override
  NotificationDataUnion rebuild(
    void Function(NotificationDataUnionBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  NotificationDataUnionBuilder toBuilder() =>
      NotificationDataUnionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationDataUnion &&
        gain == other.gain &&
        newDiamonds == other.newDiamonds &&
        rankings == other.rankings;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, gain.hashCode);
    _$hash = $jc(_$hash, newDiamonds.hashCode);
    _$hash = $jc(_$hash, rankings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationDataUnion')
          ..add('gain', gain)
          ..add('newDiamonds', newDiamonds)
          ..add('rankings', rankings))
        .toString();
  }
}

class NotificationDataUnionBuilder
    implements Builder<NotificationDataUnion, NotificationDataUnionBuilder> {
  _$NotificationDataUnion? _$v;

  num? _gain;
  num? get gain => _$this._gain;
  set gain(num? gain) => _$this._gain = gain;

  num? _newDiamonds;
  num? get newDiamonds => _$this._newDiamonds;
  set newDiamonds(num? newDiamonds) => _$this._newDiamonds = newDiamonds;

  ListBuilder<RankingEntry>? _rankings;
  ListBuilder<RankingEntry> get rankings =>
      _$this._rankings ??= ListBuilder<RankingEntry>();
  set rankings(ListBuilder<RankingEntry>? rankings) =>
      _$this._rankings = rankings;

  NotificationDataUnionBuilder();

  NotificationDataUnionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _gain = $v.gain;
      _newDiamonds = $v.newDiamonds;
      _rankings = $v.rankings?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationDataUnion other) {
    _$v = other as _$NotificationDataUnion;
  }

  @override
  void update(void Function(NotificationDataUnionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationDataUnion build() => _build();

  _$NotificationDataUnion _build() {
    _$NotificationDataUnion _$result;
    try {
      _$result =
          _$v ??
          _$NotificationDataUnion._(
            gain: gain,
            newDiamonds: newDiamonds,
            rankings: _rankings?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rankings';
        _rankings?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'NotificationDataUnion',
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
