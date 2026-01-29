// @dart=3.9
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_prediction_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdatePredictionDto extends UpdatePredictionDto {
  @override
  final num? scoreFirst;
  @override
  final num? scoreSecond;
  @override
  final num? numberOfDiamondsBet;

  factory _$UpdatePredictionDto([
    void Function(UpdatePredictionDtoBuilder)? updates,
  ]) => (UpdatePredictionDtoBuilder()..update(updates))._build();

  _$UpdatePredictionDto._({
    this.scoreFirst,
    this.scoreSecond,
    this.numberOfDiamondsBet,
  }) : super._();
  @override
  UpdatePredictionDto rebuild(
    void Function(UpdatePredictionDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdatePredictionDtoBuilder toBuilder() =>
      UpdatePredictionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdatePredictionDto &&
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
    return (newBuiltValueToStringHelper(r'UpdatePredictionDto')
          ..add('scoreFirst', scoreFirst)
          ..add('scoreSecond', scoreSecond)
          ..add('numberOfDiamondsBet', numberOfDiamondsBet))
        .toString();
  }
}

class UpdatePredictionDtoBuilder
    implements Builder<UpdatePredictionDto, UpdatePredictionDtoBuilder> {
  _$UpdatePredictionDto? _$v;

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

  UpdatePredictionDtoBuilder() {
    UpdatePredictionDto._defaults(this);
  }

  UpdatePredictionDtoBuilder get _$this {
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
  void replace(UpdatePredictionDto other) {
    _$v = other as _$UpdatePredictionDto;
  }

  @override
  void update(void Function(UpdatePredictionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdatePredictionDto build() => _build();

  _$UpdatePredictionDto _build() {
    final _$result =
        _$v ??
        _$UpdatePredictionDto._(
          scoreFirst: scoreFirst,
          scoreSecond: scoreSecond,
          numberOfDiamondsBet: numberOfDiamondsBet,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

