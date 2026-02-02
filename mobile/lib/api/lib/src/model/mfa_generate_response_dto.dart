// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_generate_response_dto.g.dart';

/// MfaGenerateResponseDto
///
/// Properties:
/// * [secret] - MFA secret key
/// * [qrCode] - QR code data URL for scanning
/// * [otpAuthUrl] - OTP Auth URL for manual setup
@BuiltValue()
abstract class MfaGenerateResponseDto implements Built<MfaGenerateResponseDto, MfaGenerateResponseDtoBuilder> {
  /// MFA secret key
  @BuiltValueField(wireName: r'secret')
  String get secret;

  /// QR code data URL for scanning
  @BuiltValueField(wireName: r'qrCode')
  String get qrCode;

  /// OTP Auth URL for manual setup
  @BuiltValueField(wireName: r'otpAuthUrl')
  String get otpAuthUrl;

  MfaGenerateResponseDto._();

  factory MfaGenerateResponseDto([void updates(MfaGenerateResponseDtoBuilder b)]) = _$MfaGenerateResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaGenerateResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaGenerateResponseDto> get serializer => _$MfaGenerateResponseDtoSerializer();
}

class _$MfaGenerateResponseDtoSerializer implements PrimitiveSerializer<MfaGenerateResponseDto> {
  @override
  final Iterable<Type> types = const [MfaGenerateResponseDto, _$MfaGenerateResponseDto];

  @override
  final String wireName = r'MfaGenerateResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaGenerateResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'secret';
    yield serializers.serialize(
      object.secret,
      specifiedType: const FullType(String),
    );
    yield r'qrCode';
    yield serializers.serialize(
      object.qrCode,
      specifiedType: const FullType(String),
    );
    yield r'otpAuthUrl';
    yield serializers.serialize(
      object.otpAuthUrl,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaGenerateResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaGenerateResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'secret':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.secret = valueDes;
          break;
        case r'qrCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.qrCode = valueDes;
          break;
        case r'otpAuthUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.otpAuthUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaGenerateResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaGenerateResponseDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


