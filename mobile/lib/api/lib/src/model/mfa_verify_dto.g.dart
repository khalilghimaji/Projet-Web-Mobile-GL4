// @dart=2.19
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_verify_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaVerifyDto extends MfaVerifyDto {
  @override
  final String code;
  @override
  final bool? rememberMe;

  factory _$MfaVerifyDto([void Function(MfaVerifyDtoBuilder)? updates]) =>
      (MfaVerifyDtoBuilder()..update(updates))._build();

  _$MfaVerifyDto._({required this.code, this.rememberMe}) : super._();
  @override
  MfaVerifyDto rebuild(void Function(MfaVerifyDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MfaVerifyDtoBuilder toBuilder() => MfaVerifyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaVerifyDto &&
        code == other.code &&
        rememberMe == other.rememberMe;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, rememberMe.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaVerifyDto')
          ..add('code', code)
          ..add('rememberMe', rememberMe))
        .toString();
  }
}

class MfaVerifyDtoBuilder
    implements Builder<MfaVerifyDto, MfaVerifyDtoBuilder> {
  _$MfaVerifyDto? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  bool? _rememberMe;
  bool? get rememberMe => _$this._rememberMe;
  set rememberMe(bool? rememberMe) => _$this._rememberMe = rememberMe;

  MfaVerifyDtoBuilder() {
    MfaVerifyDto._defaults(this);
  }

  MfaVerifyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _rememberMe = $v.rememberMe;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaVerifyDto other) {
    _$v = other as _$MfaVerifyDto;
  }

  @override
  void update(void Function(MfaVerifyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaVerifyDto build() => _build();

  _$MfaVerifyDto _build() {
    final _$result =
        _$v ??
        _$MfaVerifyDto._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'MfaVerifyDto',
            'code',
          ),
          rememberMe: rememberMe,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
