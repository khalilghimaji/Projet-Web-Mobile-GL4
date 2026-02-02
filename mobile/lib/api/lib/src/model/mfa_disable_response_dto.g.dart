// @dart=3.9
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_disable_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaDisableResponseDto extends MfaDisableResponseDto {
  @override
  final String message;

  factory _$MfaDisableResponseDto([
    void Function(MfaDisableResponseDtoBuilder)? updates,
  ]) => (MfaDisableResponseDtoBuilder()..update(updates))._build();

  _$MfaDisableResponseDto._({required this.message}) : super._();
  @override
  MfaDisableResponseDto rebuild(
    void Function(MfaDisableResponseDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MfaDisableResponseDtoBuilder toBuilder() =>
      MfaDisableResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaDisableResponseDto && message == other.message;
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
      r'MfaDisableResponseDto',
    )..add('message', message)).toString();
  }
}

class MfaDisableResponseDtoBuilder
    implements Builder<MfaDisableResponseDto, MfaDisableResponseDtoBuilder> {
  _$MfaDisableResponseDto? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  MfaDisableResponseDtoBuilder() {
    MfaDisableResponseDto._defaults(this);
  }

  MfaDisableResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaDisableResponseDto other) {
    _$v = other as _$MfaDisableResponseDto;
  }

  @override
  void update(void Function(MfaDisableResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaDisableResponseDto build() => _build();

  _$MfaDisableResponseDto _build() {
    final _$result =
        _$v ??
        _$MfaDisableResponseDto._(
          message: BuiltValueNullFieldError.checkNotNull(
            message,
            r'MfaDisableResponseDto',
            'message',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

