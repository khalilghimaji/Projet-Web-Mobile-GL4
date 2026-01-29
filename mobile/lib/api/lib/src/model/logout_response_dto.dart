// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'logout_response_dto.g.dart';

/// LogoutResponseDto
///
/// Properties:
/// * [message] - Success message after logout
@BuiltValue()
abstract class LogoutResponseDto implements Built<LogoutResponseDto, LogoutResponseDtoBuilder> {
  /// Success message after logout
  @BuiltValueField(wireName: r'message')
  String get message;

  LogoutResponseDto._();

  factory LogoutResponseDto([void updates(LogoutResponseDtoBuilder b)]) = _$LogoutResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LogoutResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LogoutResponseDto> get serializer => _$LogoutResponseDtoSerializer();
}

class _$LogoutResponseDtoSerializer implements PrimitiveSerializer<LogoutResponseDto> {
  @override
  final Iterable<Type> types = const [LogoutResponseDto, _$LogoutResponseDto];

  @override
  final String wireName = r'LogoutResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LogoutResponseDto object, {
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
    LogoutResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LogoutResponseDtoBuilder result,
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
  LogoutResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LogoutResponseDtoBuilder();
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


