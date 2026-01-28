// @dart=2.19
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logout_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LogoutResponseDto extends LogoutResponseDto {
  @override
  final String message;

  factory _$LogoutResponseDto([
    void Function(LogoutResponseDtoBuilder)? updates,
  ]) => (LogoutResponseDtoBuilder()..update(updates))._build();

  _$LogoutResponseDto._({required this.message}) : super._();
  @override
  LogoutResponseDto rebuild(void Function(LogoutResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LogoutResponseDtoBuilder toBuilder() =>
      LogoutResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LogoutResponseDto && message == other.message;
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
      r'LogoutResponseDto',
    )..add('message', message)).toString();
  }
}

class LogoutResponseDtoBuilder
    implements Builder<LogoutResponseDto, LogoutResponseDtoBuilder> {
  _$LogoutResponseDto? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  LogoutResponseDtoBuilder() {
    LogoutResponseDto._defaults(this);
  }

  LogoutResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LogoutResponseDto other) {
    _$v = other as _$LogoutResponseDto;
  }

  @override
  void update(void Function(LogoutResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LogoutResponseDto build() => _build();

  _$LogoutResponseDto _build() {
    final _$result =
        _$v ??
        _$LogoutResponseDto._(
          message: BuiltValueNullFieldError.checkNotNull(
            message,
            r'LogoutResponseDto',
            'message',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
