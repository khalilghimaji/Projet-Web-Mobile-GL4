// @dart=3.9
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_login_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FirebaseLoginDto extends FirebaseLoginDto {
  @override
  final String firebaseToken;

  factory _$FirebaseLoginDto([
    void Function(FirebaseLoginDtoBuilder)? updates,
  ]) => (FirebaseLoginDtoBuilder()..update(updates))._build();

  _$FirebaseLoginDto._({required this.firebaseToken}) : super._();
  @override
  FirebaseLoginDto rebuild(void Function(FirebaseLoginDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FirebaseLoginDtoBuilder toBuilder() =>
      FirebaseLoginDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FirebaseLoginDto && firebaseToken == other.firebaseToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, firebaseToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'FirebaseLoginDto',
    )..add('firebaseToken', firebaseToken)).toString();
  }
}

class FirebaseLoginDtoBuilder
    implements Builder<FirebaseLoginDto, FirebaseLoginDtoBuilder> {
  _$FirebaseLoginDto? _$v;

  String? _firebaseToken;
  String? get firebaseToken => _$this._firebaseToken;
  set firebaseToken(String? firebaseToken) =>
      _$this._firebaseToken = firebaseToken;

  FirebaseLoginDtoBuilder() {
    FirebaseLoginDto._defaults(this);
  }

  FirebaseLoginDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _firebaseToken = $v.firebaseToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FirebaseLoginDto other) {
    _$v = other as _$FirebaseLoginDto;
  }

  @override
  void update(void Function(FirebaseLoginDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FirebaseLoginDto build() => _build();

  _$FirebaseLoginDto _build() {
    final _$result =
        _$v ??
        _$FirebaseLoginDto._(
          firebaseToken: BuiltValueNullFieldError.checkNotNull(
            firebaseToken,
            r'FirebaseLoginDto',
            'firebaseToken',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

