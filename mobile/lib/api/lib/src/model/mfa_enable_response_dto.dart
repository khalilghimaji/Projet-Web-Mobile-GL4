// @dart=2.19
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_enable_response_dto.g.dart';

/// MfaEnableResponseDto
///
/// Properties:
/// * [message] - Success message after enabling MFA
/// * [recoveryCodes] - Recovery codes for account access if MFA device is lost
@BuiltValue()
abstract class MfaEnableResponseDto implements Built<MfaEnableResponseDto, MfaEnableResponseDtoBuilder> {
  /// Success message after enabling MFA
  @BuiltValueField(wireName: r'message')
  String get message;

  /// Recovery codes for account access if MFA device is lost
  @BuiltValueField(wireName: r'recoveryCodes')
  BuiltList<String> get recoveryCodes;

  MfaEnableResponseDto._();

  factory MfaEnableResponseDto([void updates(MfaEnableResponseDtoBuilder b)]) = _$MfaEnableResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaEnableResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaEnableResponseDto> get serializer => _$MfaEnableResponseDtoSerializer();
}

class _$MfaEnableResponseDtoSerializer implements PrimitiveSerializer<MfaEnableResponseDto> {
  @override
  final Iterable<Type> types = const [MfaEnableResponseDto, _$MfaEnableResponseDto];

  @override
  final String wireName = r'MfaEnableResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaEnableResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'recoveryCodes';
    yield serializers.serialize(
      object.recoveryCodes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaEnableResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaEnableResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'recoveryCodes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.recoveryCodes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaEnableResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaEnableResponseDtoBuilder();
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

