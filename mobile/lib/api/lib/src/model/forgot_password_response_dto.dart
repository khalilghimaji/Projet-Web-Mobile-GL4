// @dart=2.19
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'forgot_password_response_dto.g.dart';

/// ForgotPasswordResponseDto
///
/// Properties:
/// * [message] - Response message
@BuiltValue()
abstract class ForgotPasswordResponseDto implements Built<ForgotPasswordResponseDto, ForgotPasswordResponseDtoBuilder> {
  /// Response message
  @BuiltValueField(wireName: r'message')
  String get message;

  ForgotPasswordResponseDto._();

  factory ForgotPasswordResponseDto([void updates(ForgotPasswordResponseDtoBuilder b)]) = _$ForgotPasswordResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ForgotPasswordResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ForgotPasswordResponseDto> get serializer => _$ForgotPasswordResponseDtoSerializer();
}

class _$ForgotPasswordResponseDtoSerializer implements PrimitiveSerializer<ForgotPasswordResponseDto> {
  @override
  final Iterable<Type> types = const [ForgotPasswordResponseDto, _$ForgotPasswordResponseDto];

  @override
  final String wireName = r'ForgotPasswordResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ForgotPasswordResponseDto object, {
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
    ForgotPasswordResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ForgotPasswordResponseDtoBuilder result,
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
  ForgotPasswordResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ForgotPasswordResponseDtoBuilder();
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

