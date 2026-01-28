// @dart=2.19
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terminate_match_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TerminateMatchDto extends TerminateMatchDto {
  @override
  final num scoreFirst;
  @override
  final num scoreSecond;

  factory _$TerminateMatchDto([
    void Function(TerminateMatchDtoBuilder)? updates,
  ]) => (TerminateMatchDtoBuilder()..update(updates))._build();

  _$TerminateMatchDto._({required this.scoreFirst, required this.scoreSecond})
    : super._();
  @override
  TerminateMatchDto rebuild(void Function(TerminateMatchDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TerminateMatchDtoBuilder toBuilder() =>
      TerminateMatchDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TerminateMatchDto &&
        scoreFirst == other.scoreFirst &&
        scoreSecond == other.scoreSecond;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, scoreFirst.hashCode);
    _$hash = $jc(_$hash, scoreSecond.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TerminateMatchDto')
          ..add('scoreFirst', scoreFirst)
          ..add('scoreSecond', scoreSecond))
        .toString();
  }
}

class TerminateMatchDtoBuilder
    implements Builder<TerminateMatchDto, TerminateMatchDtoBuilder> {
  _$TerminateMatchDto? _$v;

  num? _scoreFirst;
  num? get scoreFirst => _$this._scoreFirst;
  set scoreFirst(num? scoreFirst) => _$this._scoreFirst = scoreFirst;

  num? _scoreSecond;
  num? get scoreSecond => _$this._scoreSecond;
  set scoreSecond(num? scoreSecond) => _$this._scoreSecond = scoreSecond;

  TerminateMatchDtoBuilder() {
    TerminateMatchDto._defaults(this);
  }

  TerminateMatchDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _scoreFirst = $v.scoreFirst;
      _scoreSecond = $v.scoreSecond;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TerminateMatchDto other) {
    _$v = other as _$TerminateMatchDto;
  }

  @override
  void update(void Function(TerminateMatchDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TerminateMatchDto build() => _build();

  _$TerminateMatchDto _build() {
    final _$result =
        _$v ??
        _$TerminateMatchDto._(
          scoreFirst: BuiltValueNullFieldError.checkNotNull(
            scoreFirst,
            r'TerminateMatchDto',
            'scoreFirst',
          ),
          scoreSecond: BuiltValueNullFieldError.checkNotNull(
            scoreSecond,
            r'TerminateMatchDto',
            'scoreSecond',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
