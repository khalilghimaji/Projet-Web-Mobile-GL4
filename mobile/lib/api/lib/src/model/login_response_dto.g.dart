// @dart=3.9
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoginResponseDto extends LoginResponseDto {
  @override
  final String? accessToken;
  @override
  final String? refreshToken;
  @override
  final UserDto? user;
  @override
  final String? message;
  @override
  final String? mfaToken;
  @override
  final bool? isMfaRequired;

  factory _$LoginResponseDto([
    void Function(LoginResponseDtoBuilder)? updates,
  ]) => (LoginResponseDtoBuilder()..update(updates))._build();

  _$LoginResponseDto._({
    this.accessToken,
    this.refreshToken,
    this.user,
    this.message,
    this.mfaToken,
    this.isMfaRequired,
  }) : super._();
  @override
  LoginResponseDto rebuild(void Function(LoginResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginResponseDtoBuilder toBuilder() =>
      LoginResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginResponseDto &&
        accessToken == other.accessToken &&
        refreshToken == other.refreshToken &&
        user == other.user &&
        message == other.message &&
        mfaToken == other.mfaToken &&
        isMfaRequired == other.isMfaRequired;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, mfaToken.hashCode);
    _$hash = $jc(_$hash, isMfaRequired.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoginResponseDto')
          ..add('accessToken', accessToken)
          ..add('refreshToken', refreshToken)
          ..add('user', user)
          ..add('message', message)
          ..add('mfaToken', mfaToken)
          ..add('isMfaRequired', isMfaRequired))
        .toString();
  }
}

class LoginResponseDtoBuilder
    implements Builder<LoginResponseDto, LoginResponseDtoBuilder> {
  _$LoginResponseDto? _$v;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  UserDtoBuilder? _user;
  UserDtoBuilder get user => _$this._user ??= UserDtoBuilder();
  set user(UserDtoBuilder? user) => _$this._user = user;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _mfaToken;
  String? get mfaToken => _$this._mfaToken;
  set mfaToken(String? mfaToken) => _$this._mfaToken = mfaToken;

  bool? _isMfaRequired;
  bool? get isMfaRequired => _$this._isMfaRequired;
  set isMfaRequired(bool? isMfaRequired) =>
      _$this._isMfaRequired = isMfaRequired;

  LoginResponseDtoBuilder() {
    LoginResponseDto._defaults(this);
  }

  LoginResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessToken = $v.accessToken;
      _refreshToken = $v.refreshToken;
      _user = $v.user?.toBuilder();
      _message = $v.message;
      _mfaToken = $v.mfaToken;
      _isMfaRequired = $v.isMfaRequired;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginResponseDto other) {
    _$v = other as _$LoginResponseDto;
  }

  @override
  void update(void Function(LoginResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginResponseDto build() => _build();

  _$LoginResponseDto _build() {
    _$LoginResponseDto _$result;
    try {
      _$result =
          _$v ??
          _$LoginResponseDto._(
            accessToken: accessToken,
            refreshToken: refreshToken,
            user: _user?.build(),
            message: message,
            mfaToken: mfaToken,
            isMfaRequired: isMfaRequired,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'LoginResponseDto',
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

