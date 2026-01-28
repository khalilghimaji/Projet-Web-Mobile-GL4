// @dart=2.19
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_disable_response_dto.g.dart';

/// MfaDisableResponseDto
///
/// Properties:
/// * [message] - Success message after disabling MFA
@BuiltValue()
abstract class MfaDisableResponseDto implements Built<MfaDisableResponseDto, MfaDisableResponseDtoBuilder> {
  /// Success message after disabling MFA
  @BuiltValueField(wireName: r'message')
  String get message;

  MfaDisableResponseDto._();

  factory MfaDisableResponseDto([void updates(MfaDisableResponseDtoBuilder b)]) = _$MfaDisableResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaDisableResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaDisableResponseDto> get serializer => _$MfaDisableResponseDtoSerializer();
}

class _$MfaDisableResponseDtoSerializer implements PrimitiveSerializer<MfaDisableResponseDto> {
  @override
  final Iterable<Type> types = const [MfaDisableResponseDto, _$MfaDisableResponseDto];

  @override
  final String wireName = r'MfaDisableResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaDisableResponseDto object, {
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
    MfaDisableResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaDisableResponseDtoBuilder result,
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
  MfaDisableResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaDisableResponseDtoBuilder();
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

