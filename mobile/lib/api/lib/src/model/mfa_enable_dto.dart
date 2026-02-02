// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_enable_dto.g.dart';

/// MfaEnableDto
///
/// Properties:
/// * [code] 
@BuiltValue()
abstract class MfaEnableDto implements Built<MfaEnableDto, MfaEnableDtoBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  MfaEnableDto._();

  factory MfaEnableDto([void updates(MfaEnableDtoBuilder b)]) = _$MfaEnableDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaEnableDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaEnableDto> get serializer => _$MfaEnableDtoSerializer();
}

class _$MfaEnableDtoSerializer implements PrimitiveSerializer<MfaEnableDto> {
  @override
  final Iterable<Type> types = const [MfaEnableDto, _$MfaEnableDto];

  @override
  final String wireName = r'MfaEnableDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaEnableDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaEnableDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaEnableDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaEnableDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaEnableDtoBuilder();
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


