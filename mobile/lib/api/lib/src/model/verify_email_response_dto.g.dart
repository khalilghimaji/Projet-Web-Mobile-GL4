// @dart=2.19
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_email_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VerifyEmailResponseDto extends VerifyEmailResponseDto {
  @override
  final String message;

  factory _$VerifyEmailResponseDto([
    void Function(VerifyEmailResponseDtoBuilder)? updates,
  ]) => (VerifyEmailResponseDtoBuilder()..update(updates))._build();

  _$VerifyEmailResponseDto._({required this.message}) : super._();
  @override
  VerifyEmailResponseDto rebuild(
    void Function(VerifyEmailResponseDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  VerifyEmailResponseDtoBuilder toBuilder() =>
      VerifyEmailResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VerifyEmailResponseDto && message == other.message;
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
      r'VerifyEmailResponseDto',
    )..add('message', message)).toString();
  }
}

class VerifyEmailResponseDtoBuilder
    implements Builder<VerifyEmailResponseDto, VerifyEmailResponseDtoBuilder> {
  _$VerifyEmailResponseDto? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  VerifyEmailResponseDtoBuilder() {
    VerifyEmailResponseDto._defaults(this);
  }

  VerifyEmailResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VerifyEmailResponseDto other) {
    _$v = other as _$VerifyEmailResponseDto;
  }

  @override
  void update(void Function(VerifyEmailResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VerifyEmailResponseDto build() => _build();

  _$VerifyEmailResponseDto _build() {
    final _$result =
        _$v ??
        _$VerifyEmailResponseDto._(
          message: BuiltValueNullFieldError.checkNotNull(
            message,
            r'VerifyEmailResponseDto',
            'message',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
