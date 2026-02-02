// @dart=3.9
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_stat.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MatchStat extends MatchStat {
  @override
  final num totalVotes;
  @override
  final num homePercentage;
  @override
  final num drawPercentage;
  @override
  final num awayPercentage;
  @override
  final bool voteEnabled;

  factory _$MatchStat([void Function(MatchStatBuilder)? updates]) =>
      (MatchStatBuilder()..update(updates))._build();

  _$MatchStat._({
    required this.totalVotes,
    required this.homePercentage,
    required this.drawPercentage,
    required this.awayPercentage,
    required this.voteEnabled,
  }) : super._();
  @override
  MatchStat rebuild(void Function(MatchStatBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MatchStatBuilder toBuilder() => MatchStatBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MatchStat &&
        totalVotes == other.totalVotes &&
        homePercentage == other.homePercentage &&
        drawPercentage == other.drawPercentage &&
        awayPercentage == other.awayPercentage &&
        voteEnabled == other.voteEnabled;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, totalVotes.hashCode);
    _$hash = $jc(_$hash, homePercentage.hashCode);
    _$hash = $jc(_$hash, drawPercentage.hashCode);
    _$hash = $jc(_$hash, awayPercentage.hashCode);
    _$hash = $jc(_$hash, voteEnabled.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MatchStat')
          ..add('totalVotes', totalVotes)
          ..add('homePercentage', homePercentage)
          ..add('drawPercentage', drawPercentage)
          ..add('awayPercentage', awayPercentage)
          ..add('voteEnabled', voteEnabled))
        .toString();
  }
}

class MatchStatBuilder implements Builder<MatchStat, MatchStatBuilder> {
  _$MatchStat? _$v;

  num? _totalVotes;
  num? get totalVotes => _$this._totalVotes;
  set totalVotes(num? totalVotes) => _$this._totalVotes = totalVotes;

  num? _homePercentage;
  num? get homePercentage => _$this._homePercentage;
  set homePercentage(num? homePercentage) =>
      _$this._homePercentage = homePercentage;

  num? _drawPercentage;
  num? get drawPercentage => _$this._drawPercentage;
  set drawPercentage(num? drawPercentage) =>
      _$this._drawPercentage = drawPercentage;

  num? _awayPercentage;
  num? get awayPercentage => _$this._awayPercentage;
  set awayPercentage(num? awayPercentage) =>
      _$this._awayPercentage = awayPercentage;

  bool? _voteEnabled;
  bool? get voteEnabled => _$this._voteEnabled;
  set voteEnabled(bool? voteEnabled) => _$this._voteEnabled = voteEnabled;

  MatchStatBuilder() {
    MatchStat._defaults(this);
  }

  MatchStatBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _totalVotes = $v.totalVotes;
      _homePercentage = $v.homePercentage;
      _drawPercentage = $v.drawPercentage;
      _awayPercentage = $v.awayPercentage;
      _voteEnabled = $v.voteEnabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MatchStat other) {
    _$v = other as _$MatchStat;
  }

  @override
  void update(void Function(MatchStatBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MatchStat build() => _build();

  _$MatchStat _build() {
    final _$result =
        _$v ??
        _$MatchStat._(
          totalVotes: BuiltValueNullFieldError.checkNotNull(
            totalVotes,
            r'MatchStat',
            'totalVotes',
          ),
          homePercentage: BuiltValueNullFieldError.checkNotNull(
            homePercentage,
            r'MatchStat',
            'homePercentage',
          ),
          drawPercentage: BuiltValueNullFieldError.checkNotNull(
            drawPercentage,
            r'MatchStat',
            'drawPercentage',
          ),
          awayPercentage: BuiltValueNullFieldError.checkNotNull(
            awayPercentage,
            r'MatchStat',
            'awayPercentage',
          ),
          voteEnabled: BuiltValueNullFieldError.checkNotNull(
            voteEnabled,
            r'MatchStat',
            'voteEnabled',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

