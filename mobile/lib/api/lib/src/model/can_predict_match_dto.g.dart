// @dart=3.9
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'can_predict_match_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CanPredictMatchDto extends CanPredictMatchDto {
  @override
  final num numberOfDiamondsBet;

  factory _$CanPredictMatchDto([
    void Function(CanPredictMatchDtoBuilder)? updates,
  ]) => (CanPredictMatchDtoBuilder()..update(updates))._build();

  _$CanPredictMatchDto._({required this.numberOfDiamondsBet}) : super._();
  @override
  CanPredictMatchDto rebuild(
    void Function(CanPredictMatchDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CanPredictMatchDtoBuilder toBuilder() =>
      CanPredictMatchDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CanPredictMatchDto &&
        numberOfDiamondsBet == other.numberOfDiamondsBet;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, numberOfDiamondsBet.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CanPredictMatchDto',
    )..add('numberOfDiamondsBet', numberOfDiamondsBet)).toString();
  }
}

class CanPredictMatchDtoBuilder
    implements Builder<CanPredictMatchDto, CanPredictMatchDtoBuilder> {
  _$CanPredictMatchDto? _$v;

  num? _numberOfDiamondsBet;
  num? get numberOfDiamondsBet => _$this._numberOfDiamondsBet;
  set numberOfDiamondsBet(num? numberOfDiamondsBet) =>
      _$this._numberOfDiamondsBet = numberOfDiamondsBet;

  CanPredictMatchDtoBuilder() {
    CanPredictMatchDto._defaults(this);
  }

  CanPredictMatchDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _numberOfDiamondsBet = $v.numberOfDiamondsBet;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CanPredictMatchDto other) {
    _$v = other as _$CanPredictMatchDto;
  }

  @override
  void update(void Function(CanPredictMatchDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CanPredictMatchDto build() => _build();

  _$CanPredictMatchDto _build() {
    final _$result =
        _$v ??
        _$CanPredictMatchDto._(
          numberOfDiamondsBet: BuiltValueNullFieldError.checkNotNull(
            numberOfDiamondsBet,
            r'CanPredictMatchDto',
            'numberOfDiamondsBet',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

