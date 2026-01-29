// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sign_up_response_dto.g.dart';

/// SignUpResponseDto
///
/// Properties:
/// * [message] - Success message after signup
@BuiltValue()
abstract class SignUpResponseDto implements Built<SignUpResponseDto, SignUpResponseDtoBuilder> {
  /// Success message after signup
  @BuiltValueField(wireName: r'message')
  String get message;

  SignUpResponseDto._();

  factory SignUpResponseDto([void updates(SignUpResponseDtoBuilder b)]) = _$SignUpResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SignUpResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SignUpResponseDto> get serializer => _$SignUpResponseDtoSerializer();
}

class _$SignUpResponseDtoSerializer implements PrimitiveSerializer<SignUpResponseDto> {
  @override
  final Iterable<Type> types = const [SignUpResponseDto, _$SignUpResponseDto];

  @override
  final String wireName = r'SignUpResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SignUpResponseDto object, {
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
    SignUpResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SignUpResponseDtoBuilder result,
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
  SignUpResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SignUpResponseDtoBuilder();
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


