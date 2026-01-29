// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'verify_email_response_dto.g.dart';

/// VerifyEmailResponseDto
///
/// Properties:
/// * [message] - Success message after email verification
@BuiltValue()
abstract class VerifyEmailResponseDto implements Built<VerifyEmailResponseDto, VerifyEmailResponseDtoBuilder> {
  /// Success message after email verification
  @BuiltValueField(wireName: r'message')
  String get message;

  VerifyEmailResponseDto._();

  factory VerifyEmailResponseDto([void updates(VerifyEmailResponseDtoBuilder b)]) = _$VerifyEmailResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VerifyEmailResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VerifyEmailResponseDto> get serializer => _$VerifyEmailResponseDtoSerializer();
}

class _$VerifyEmailResponseDtoSerializer implements PrimitiveSerializer<VerifyEmailResponseDto> {
  @override
  final Iterable<Type> types = const [VerifyEmailResponseDto, _$VerifyEmailResponseDto];

  @override
  final String wireName = r'VerifyEmailResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VerifyEmailResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VerifyEmailResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VerifyEmailResponseDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VerifyEmailResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VerifyEmailResponseDtoBuilder();
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


