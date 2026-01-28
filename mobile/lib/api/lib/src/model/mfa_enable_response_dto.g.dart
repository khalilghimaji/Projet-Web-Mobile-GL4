// @dart=2.19
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_enable_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaEnableResponseDto extends MfaEnableResponseDto {
  @override
  final String message;
  @override
  final BuiltList<String> recoveryCodes;

  factory _$MfaEnableResponseDto([
    void Function(MfaEnableResponseDtoBuilder)? updates,
  ]) => (MfaEnableResponseDtoBuilder()..update(updates))._build();

  _$MfaEnableResponseDto._({required this.message, required this.recoveryCodes})
    : super._();
  @override
  MfaEnableResponseDto rebuild(
    void Function(MfaEnableResponseDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MfaEnableResponseDtoBuilder toBuilder() =>
      MfaEnableResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaEnableResponseDto &&
        message == other.message &&
        recoveryCodes == other.recoveryCodes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, recoveryCodes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaEnableResponseDto')
          ..add('message', message)
          ..add('recoveryCodes', recoveryCodes))
        .toString();
  }
}

class MfaEnableResponseDtoBuilder
    implements Builder<MfaEnableResponseDto, MfaEnableResponseDtoBuilder> {
  _$MfaEnableResponseDto? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ListBuilder<String>? _recoveryCodes;
  ListBuilder<String> get recoveryCodes =>
      _$this._recoveryCodes ??= ListBuilder<String>();
  set recoveryCodes(ListBuilder<String>? recoveryCodes) =>
      _$this._recoveryCodes = recoveryCodes;

  MfaEnableResponseDtoBuilder() {
    MfaEnableResponseDto._defaults(this);
  }

  MfaEnableResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _recoveryCodes = $v.recoveryCodes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaEnableResponseDto other) {
    _$v = other as _$MfaEnableResponseDto;
  }

  @override
  void update(void Function(MfaEnableResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaEnableResponseDto build() => _build();

  _$MfaEnableResponseDto _build() {
    _$MfaEnableResponseDto _$result;
    try {
      _$result =
          _$v ??
          _$MfaEnableResponseDto._(
            message: BuiltValueNullFieldError.checkNotNull(
              message,
              r'MfaEnableResponseDto',
              'message',
            ),
            recoveryCodes: recoveryCodes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'recoveryCodes';
        recoveryCodes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MfaEnableResponseDto',
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
