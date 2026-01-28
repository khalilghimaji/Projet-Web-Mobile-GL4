// @dart=2.19
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_verify_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaVerifyResponseDto extends MfaVerifyResponseDto {
  @override
  final String? accessToken;
  @override
  final String? refreshToken;
  @override
  final UserDto user;

  factory _$MfaVerifyResponseDto([
    void Function(MfaVerifyResponseDtoBuilder)? updates,
  ]) => (MfaVerifyResponseDtoBuilder()..update(updates))._build();

  _$MfaVerifyResponseDto._({
    this.accessToken,
    this.refreshToken,
    required this.user,
  }) : super._();
  @override
  MfaVerifyResponseDto rebuild(
    void Function(MfaVerifyResponseDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MfaVerifyResponseDtoBuilder toBuilder() =>
      MfaVerifyResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaVerifyResponseDto &&
        accessToken == other.accessToken &&
        refreshToken == other.refreshToken &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaVerifyResponseDto')
          ..add('accessToken', accessToken)
          ..add('refreshToken', refreshToken)
          ..add('user', user))
        .toString();
  }
}

class MfaVerifyResponseDtoBuilder
    implements Builder<MfaVerifyResponseDto, MfaVerifyResponseDtoBuilder> {
  _$MfaVerifyResponseDto? _$v;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  UserDtoBuilder? _user;
  UserDtoBuilder get user => _$this._user ??= UserDtoBuilder();
  set user(UserDtoBuilder? user) => _$this._user = user;

  MfaVerifyResponseDtoBuilder() {
    MfaVerifyResponseDto._defaults(this);
  }

  MfaVerifyResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessToken = $v.accessToken;
      _refreshToken = $v.refreshToken;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaVerifyResponseDto other) {
    _$v = other as _$MfaVerifyResponseDto;
  }

  @override
  void update(void Function(MfaVerifyResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaVerifyResponseDto build() => _build();

  _$MfaVerifyResponseDto _build() {
    _$MfaVerifyResponseDto _$result;
    try {
      _$result =
          _$v ??
          _$MfaVerifyResponseDto._(
            accessToken: accessToken,
            refreshToken: refreshToken,
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MfaVerifyResponseDto',
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
