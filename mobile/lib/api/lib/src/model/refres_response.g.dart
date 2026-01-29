// @dart=3.9
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refres_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RefresResponse extends RefresResponse {
  @override
  final String message;

  factory _$RefresResponse([void Function(RefresResponseBuilder)? updates]) =>
      (RefresResponseBuilder()..update(updates))._build();

  _$RefresResponse._({required this.message}) : super._();
  @override
  RefresResponse rebuild(void Function(RefresResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RefresResponseBuilder toBuilder() => RefresResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RefresResponse && message == other.message;
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
      r'RefresResponse',
    )..add('message', message)).toString();
  }
}

class RefresResponseBuilder
    implements Builder<RefresResponse, RefresResponseBuilder> {
  _$RefresResponse? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  RefresResponseBuilder() {
    RefresResponse._defaults(this);
  }

  RefresResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RefresResponse other) {
    _$v = other as _$RefresResponse;
  }

  @override
  void update(void Function(RefresResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RefresResponse build() => _build();

  _$RefresResponse _build() {
    final _$result =
        _$v ??
        _$RefresResponse._(
          message: BuiltValueNullFieldError.checkNotNull(
            message,
            r'RefresResponse',
            'message',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

