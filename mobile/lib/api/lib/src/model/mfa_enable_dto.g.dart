// @dart=2.19
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_enable_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaEnableDto extends MfaEnableDto {
  @override
  final String code;

  factory _$MfaEnableDto([void Function(MfaEnableDtoBuilder)? updates]) =>
      (MfaEnableDtoBuilder()..update(updates))._build();

  _$MfaEnableDto._({required this.code}) : super._();
  @override
  MfaEnableDto rebuild(void Function(MfaEnableDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MfaEnableDtoBuilder toBuilder() => MfaEnableDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaEnableDto && code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MfaEnableDto',
    )..add('code', code)).toString();
  }
}

class MfaEnableDtoBuilder
    implements Builder<MfaEnableDto, MfaEnableDtoBuilder> {
  _$MfaEnableDto? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  MfaEnableDtoBuilder() {
    MfaEnableDto._defaults(this);
  }

  MfaEnableDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaEnableDto other) {
    _$v = other as _$MfaEnableDto;
  }

  @override
  void update(void Function(MfaEnableDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaEnableDto build() => _build();

  _$MfaEnableDto _build() {
    final _$result =
        _$v ??
        _$MfaEnableDto._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'MfaEnableDto',
            'code',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
