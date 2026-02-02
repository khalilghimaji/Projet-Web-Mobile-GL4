// @dart=3.9
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResetPasswordResponseDto extends ResetPasswordResponseDto {
  @override
  final String message;

  factory _$ResetPasswordResponseDto([
    void Function(ResetPasswordResponseDtoBuilder)? updates,
  ]) => (ResetPasswordResponseDtoBuilder()..update(updates))._build();

  _$ResetPasswordResponseDto._({required this.message}) : super._();
  @override
  ResetPasswordResponseDto rebuild(
    void Function(ResetPasswordResponseDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ResetPasswordResponseDtoBuilder toBuilder() =>
      ResetPasswordResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResetPasswordResponseDto && message == other.message;
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
      r'ResetPasswordResponseDto',
    )..add('message', message)).toString();
  }
}

class ResetPasswordResponseDtoBuilder
    implements
        Builder<ResetPasswordResponseDto, ResetPasswordResponseDtoBuilder> {
  _$ResetPasswordResponseDto? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ResetPasswordResponseDtoBuilder() {
    ResetPasswordResponseDto._defaults(this);
  }

  ResetPasswordResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResetPasswordResponseDto other) {
    _$v = other as _$ResetPasswordResponseDto;
  }

  @override
  void update(void Function(ResetPasswordResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResetPasswordResponseDto build() => _build();

  _$ResetPasswordResponseDto _build() {
    final _$result =
        _$v ??
        _$ResetPasswordResponseDto._(
          message: BuiltValueNullFieldError.checkNotNull(
            message,
            r'ResetPasswordResponseDto',
            'message',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

