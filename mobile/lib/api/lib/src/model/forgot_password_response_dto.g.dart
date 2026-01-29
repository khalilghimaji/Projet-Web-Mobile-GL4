// @dart=3.9
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ForgotPasswordResponseDto extends ForgotPasswordResponseDto {
  @override
  final String message;

  factory _$ForgotPasswordResponseDto([
    void Function(ForgotPasswordResponseDtoBuilder)? updates,
  ]) => (ForgotPasswordResponseDtoBuilder()..update(updates))._build();

  _$ForgotPasswordResponseDto._({required this.message}) : super._();
  @override
  ForgotPasswordResponseDto rebuild(
    void Function(ForgotPasswordResponseDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ForgotPasswordResponseDtoBuilder toBuilder() =>
      ForgotPasswordResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ForgotPasswordResponseDto && message == other.message;
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
      r'ForgotPasswordResponseDto',
    )..add('message', message)).toString();
  }
}

class ForgotPasswordResponseDtoBuilder
    implements
        Builder<ForgotPasswordResponseDto, ForgotPasswordResponseDtoBuilder> {
  _$ForgotPasswordResponseDto? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ForgotPasswordResponseDtoBuilder() {
    ForgotPasswordResponseDto._defaults(this);
  }

  ForgotPasswordResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ForgotPasswordResponseDto other) {
    _$v = other as _$ForgotPasswordResponseDto;
  }

  @override
  void update(void Function(ForgotPasswordResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ForgotPasswordResponseDto build() => _build();

  _$ForgotPasswordResponseDto _build() {
    final _$result =
        _$v ??
        _$ForgotPasswordResponseDto._(
          message: BuiltValueNullFieldError.checkNotNull(
            message,
            r'ForgotPasswordResponseDto',
            'message',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

