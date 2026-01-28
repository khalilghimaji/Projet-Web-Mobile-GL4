// @dart=2.19
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserDto extends UserDto {
  @override
  final String id;
  @override
  final String email;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? imgUrl;
  @override
  final bool? isMFAEnabled;
  @override
  final num diamonds;

  factory _$UserDto([void Function(UserDtoBuilder)? updates]) =>
      (UserDtoBuilder()..update(updates))._build();

  _$UserDto._({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.imgUrl,
    this.isMFAEnabled,
    required this.diamonds,
  }) : super._();
  @override
  UserDto rebuild(void Function(UserDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserDtoBuilder toBuilder() => UserDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserDto &&
        id == other.id &&
        email == other.email &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        imgUrl == other.imgUrl &&
        isMFAEnabled == other.isMFAEnabled &&
        diamonds == other.diamonds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, imgUrl.hashCode);
    _$hash = $jc(_$hash, isMFAEnabled.hashCode);
    _$hash = $jc(_$hash, diamonds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserDto')
          ..add('id', id)
          ..add('email', email)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('imgUrl', imgUrl)
          ..add('isMFAEnabled', isMFAEnabled)
          ..add('diamonds', diamonds))
        .toString();
  }
}

class UserDtoBuilder implements Builder<UserDto, UserDtoBuilder> {
  _$UserDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _imgUrl;
  String? get imgUrl => _$this._imgUrl;
  set imgUrl(String? imgUrl) => _$this._imgUrl = imgUrl;

  bool? _isMFAEnabled;
  bool? get isMFAEnabled => _$this._isMFAEnabled;
  set isMFAEnabled(bool? isMFAEnabled) => _$this._isMFAEnabled = isMFAEnabled;

  num? _diamonds;
  num? get diamonds => _$this._diamonds;
  set diamonds(num? diamonds) => _$this._diamonds = diamonds;

  UserDtoBuilder() {
    UserDto._defaults(this);
  }

  UserDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _email = $v.email;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _imgUrl = $v.imgUrl;
      _isMFAEnabled = $v.isMFAEnabled;
      _diamonds = $v.diamonds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserDto other) {
    _$v = other as _$UserDto;
  }

  @override
  void update(void Function(UserDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserDto build() => _build();

  _$UserDto _build() {
    final _$result =
        _$v ??
        _$UserDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'UserDto', 'id'),
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'UserDto',
            'email',
          ),
          firstName: BuiltValueNullFieldError.checkNotNull(
            firstName,
            r'UserDto',
            'firstName',
          ),
          lastName: BuiltValueNullFieldError.checkNotNull(
            lastName,
            r'UserDto',
            'lastName',
          ),
          imgUrl: imgUrl,
          isMFAEnabled: isMFAEnabled,
          diamonds: BuiltValueNullFieldError.checkNotNull(
            diamonds,
            r'UserDto',
            'diamonds',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
