// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reset_password_response_dto.g.dart';

/// ResetPasswordResponseDto
///
/// Properties:
/// * [message] - Response message
@BuiltValue()
abstract class ResetPasswordResponseDto implements Built<ResetPasswordResponseDto, ResetPasswordResponseDtoBuilder> {
  /// Response message
  @BuiltValueField(wireName: r'message')
  String get message;

  ResetPasswordResponseDto._();

  factory ResetPasswordResponseDto([void updates(ResetPasswordResponseDtoBuilder b)]) = _$ResetPasswordResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResetPasswordResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResetPasswordResponseDto> get serializer => _$ResetPasswordResponseDtoSerializer();
}

class _$ResetPasswordResponseDtoSerializer implements PrimitiveSerializer<ResetPasswordResponseDto> {
  @override
  final Iterable<Type> types = const [ResetPasswordResponseDto, _$ResetPasswordResponseDto];

  @override
  final String wireName = r'ResetPasswordResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResetPasswordResponseDto object, {
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
    ResetPasswordResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ResetPasswordResponseDtoBuilder result,
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
  ResetPasswordResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResetPasswordResponseDtoBuilder();
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


