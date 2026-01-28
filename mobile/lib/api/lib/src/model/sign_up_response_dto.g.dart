// @dart=2.19
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SignUpResponseDto extends SignUpResponseDto {
  @override
  final String message;

  factory _$SignUpResponseDto([
    void Function(SignUpResponseDtoBuilder)? updates,
  ]) => (SignUpResponseDtoBuilder()..update(updates))._build();

  _$SignUpResponseDto._({required this.message}) : super._();
  @override
  SignUpResponseDto rebuild(void Function(SignUpResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SignUpResponseDtoBuilder toBuilder() =>
      SignUpResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SignUpResponseDto && message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'SignUpResponseDto',
    )..add('message', message)).toString();
  }
}

class SignUpResponseDtoBuilder
    implements Builder<SignUpResponseDto, SignUpResponseDtoBuilder> {
  _$SignUpResponseDto? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  SignUpResponseDtoBuilder() {
    SignUpResponseDto._defaults(this);
  }

  SignUpResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SignUpResponseDto other) {
    _$v = other as _$SignUpResponseDto;
  }

  @override
  void update(void Function(SignUpResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SignUpResponseDto build() => _build();

  _$SignUpResponseDto _build() {
    final _$result =
        _$v ??
        _$SignUpResponseDto._(
          message: BuiltValueNullFieldError.checkNotNull(
            message,
            r'SignUpResponseDto',
            'message',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
