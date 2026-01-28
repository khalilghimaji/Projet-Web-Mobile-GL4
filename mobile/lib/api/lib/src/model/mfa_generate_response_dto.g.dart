// @dart=2.19
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_generate_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaGenerateResponseDto extends MfaGenerateResponseDto {
  @override
  final String secret;
  @override
  final String qrCode;
  @override
  final String otpAuthUrl;

  factory _$MfaGenerateResponseDto([
    void Function(MfaGenerateResponseDtoBuilder)? updates,
  ]) => (MfaGenerateResponseDtoBuilder()..update(updates))._build();

  _$MfaGenerateResponseDto._({
    required this.secret,
    required this.qrCode,
    required this.otpAuthUrl,
  }) : super._();
  @override
  MfaGenerateResponseDto rebuild(
    void Function(MfaGenerateResponseDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MfaGenerateResponseDtoBuilder toBuilder() =>
      MfaGenerateResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaGenerateResponseDto &&
        secret == other.secret &&
        qrCode == other.qrCode &&
        otpAuthUrl == other.otpAuthUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, secret.hashCode);
    _$hash = $jc(_$hash, qrCode.hashCode);
    _$hash = $jc(_$hash, otpAuthUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaGenerateResponseDto')
          ..add('secret', secret)
          ..add('qrCode', qrCode)
          ..add('otpAuthUrl', otpAuthUrl))
        .toString();
  }
}

class MfaGenerateResponseDtoBuilder
    implements Builder<MfaGenerateResponseDto, MfaGenerateResponseDtoBuilder> {
  _$MfaGenerateResponseDto? _$v;

  String? _secret;
  String? get secret => _$this._secret;
  set secret(String? secret) => _$this._secret = secret;

  String? _qrCode;
  String? get qrCode => _$this._qrCode;
  set qrCode(String? qrCode) => _$this._qrCode = qrCode;

  String? _otpAuthUrl;
  String? get otpAuthUrl => _$this._otpAuthUrl;
  set otpAuthUrl(String? otpAuthUrl) => _$this._otpAuthUrl = otpAuthUrl;

  MfaGenerateResponseDtoBuilder() {
    MfaGenerateResponseDto._defaults(this);
  }

  MfaGenerateResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _secret = $v.secret;
      _qrCode = $v.qrCode;
      _otpAuthUrl = $v.otpAuthUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaGenerateResponseDto other) {
    _$v = other as _$MfaGenerateResponseDto;
  }

  @override
  void update(void Function(MfaGenerateResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaGenerateResponseDto build() => _build();

  _$MfaGenerateResponseDto _build() {
    final _$result =
        _$v ??
        _$MfaGenerateResponseDto._(
          secret: BuiltValueNullFieldError.checkNotNull(
            secret,
            r'MfaGenerateResponseDto',
            'secret',
          ),
          qrCode: BuiltValueNullFieldError.checkNotNull(
            qrCode,
            r'MfaGenerateResponseDto',
            'qrCode',
          ),
          otpAuthUrl: BuiltValueNullFieldError.checkNotNull(
            otpAuthUrl,
            r'MfaGenerateResponseDto',
            'otpAuthUrl',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
