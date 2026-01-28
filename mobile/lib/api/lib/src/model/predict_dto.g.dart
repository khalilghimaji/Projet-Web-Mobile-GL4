// @dart=2.19
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predict_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PredictDto extends PredictDto {
  @override
  final num scoreFirst;
  @override
  final num scoreSecond;
  @override
  final num numberOfDiamondsBet;

  factory _$PredictDto([void Function(PredictDtoBuilder)? updates]) =>
      (PredictDtoBuilder()..update(updates))._build();

  _$PredictDto._({
    required this.scoreFirst,
    required this.scoreSecond,
    required this.numberOfDiamondsBet,
  }) : super._();
  @override
  PredictDto rebuild(void Function(PredictDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PredictDtoBuilder toBuilder() => PredictDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PredictDto &&
        scoreFirst == other.scoreFirst &&
        scoreSecond == other.scoreSecond &&
        numberOfDiamondsBet == other.numberOfDiamondsBet;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, scoreFirst.hashCode);
    _$hash = $jc(_$hash, scoreSecond.hashCode);
    _$hash = $jc(_$hash, numberOfDiamondsBet.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PredictDto')
          ..add('scoreFirst', scoreFirst)
          ..add('scoreSecond', scoreSecond)
          ..add('numberOfDiamondsBet', numberOfDiamondsBet))
        .toString();
  }
}

class PredictDtoBuilder implements Builder<PredictDto, PredictDtoBuilder> {
  _$PredictDto? _$v;

  num? _scoreFirst;
  num? get scoreFirst => _$this._scoreFirst;
  set scoreFirst(num? scoreFirst) => _$this._scoreFirst = scoreFirst;

  num? _scoreSecond;
  num? get scoreSecond => _$this._scoreSecond;
  set scoreSecond(num? scoreSecond) => _$this._scoreSecond = scoreSecond;

  num? _numberOfDiamondsBet;
  num? get numberOfDiamondsBet => _$this._numberOfDiamondsBet;
  set numberOfDiamondsBet(num? numberOfDiamondsBet) =>
      _$this._numberOfDiamondsBet = numberOfDiamondsBet;

  PredictDtoBuilder() {
    PredictDto._defaults(this);
  }

  PredictDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _scoreFirst = $v.scoreFirst;
      _scoreSecond = $v.scoreSecond;
      _numberOfDiamondsBet = $v.numberOfDiamondsBet;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PredictDto other) {
    _$v = other as _$PredictDto;
  }

  @override
  void update(void Function(PredictDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PredictDto build() => _build();

  _$PredictDto _build() {
    final _$result =
        _$v ??
        _$PredictDto._(
          scoreFirst: BuiltValueNullFieldError.checkNotNull(
            scoreFirst,
            r'PredictDto',
            'scoreFirst',
          ),
          scoreSecond: BuiltValueNullFieldError.checkNotNull(
            scoreSecond,
            r'PredictDto',
            'scoreSecond',
          ),
          numberOfDiamondsBet: BuiltValueNullFieldError.checkNotNull(
            numberOfDiamondsBet,
            r'PredictDto',
            'numberOfDiamondsBet',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
