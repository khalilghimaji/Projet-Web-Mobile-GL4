// @dart=2.19
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_auth_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OAuthResponseDto extends OAuthResponseDto {
  @override
  final String? accessToken;
  @override
  final String? refreshToken;
  @override
  final UserDto user;

  factory _$OAuthResponseDto([
    void Function(OAuthResponseDtoBuilder)? updates,
  ]) => (OAuthResponseDtoBuilder()..update(updates))._build();

  _$OAuthResponseDto._({
    this.accessToken,
    this.refreshToken,
    required this.user,
  }) : super._();
  @override
  OAuthResponseDto rebuild(void Function(OAuthResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OAuthResponseDtoBuilder toBuilder() =>
      OAuthResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OAuthResponseDto &&
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
    return (newBuiltValueToStringHelper(r'OAuthResponseDto')
          ..add('accessToken', accessToken)
          ..add('refreshToken', refreshToken)
          ..add('user', user))
        .toString();
  }
}

class OAuthResponseDtoBuilder
    implements Builder<OAuthResponseDto, OAuthResponseDtoBuilder> {
  _$OAuthResponseDto? _$v;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  UserDtoBuilder? _user;
  UserDtoBuilder get user => _$this._user ??= UserDtoBuilder();
  set user(UserDtoBuilder? user) => _$this._user = user;

  OAuthResponseDtoBuilder() {
    OAuthResponseDto._defaults(this);
  }

  OAuthResponseDtoBuilder get _$this {
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
  void replace(OAuthResponseDto other) {
    _$v = other as _$OAuthResponseDto;
  }

  @override
  void update(void Function(OAuthResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OAuthResponseDto build() => _build();

  _$OAuthResponseDto _build() {
    _$OAuthResponseDto _$result;
    try {
      _$result =
          _$v ??
          _$OAuthResponseDto._(
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
          r'OAuthResponseDto',
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
