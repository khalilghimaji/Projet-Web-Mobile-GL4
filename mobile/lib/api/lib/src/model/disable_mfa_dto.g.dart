// @dart=3.9
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disable_mfa_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisableMfaDto extends DisableMfaDto {
  @override
  final String password;

  factory _$DisableMfaDto([void Function(DisableMfaDtoBuilder)? updates]) =>
      (DisableMfaDtoBuilder()..update(updates))._build();

  _$DisableMfaDto._({required this.password}) : super._();
  @override
  DisableMfaDto rebuild(void Function(DisableMfaDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisableMfaDtoBuilder toBuilder() => DisableMfaDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisableMfaDto && password == other.password;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'DisableMfaDto',
    )..add('password', password)).toString();
  }
}

class DisableMfaDtoBuilder
    implements Builder<DisableMfaDto, DisableMfaDtoBuilder> {
  _$DisableMfaDto? _$v;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  DisableMfaDtoBuilder() {
    DisableMfaDto._defaults(this);
  }

  DisableMfaDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisableMfaDto other) {
    _$v = other as _$DisableMfaDto;
  }

  @override
  void update(void Function(DisableMfaDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisableMfaDto build() => _build();

  _$DisableMfaDto _build() {
    final _$result =
        _$v ??
        _$DisableMfaDto._(
          password: BuiltValueNullFieldError.checkNotNull(
            password,
            r'DisableMfaDto',
            'password',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

