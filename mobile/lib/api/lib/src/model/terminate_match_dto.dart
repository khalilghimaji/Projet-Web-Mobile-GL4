// @dart=2.19
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'terminate_match_dto.g.dart';

/// TerminateMatchDto
///
/// Properties:
/// * [scoreFirst] 
/// * [scoreSecond] 
@BuiltValue()
abstract class TerminateMatchDto implements Built<TerminateMatchDto, TerminateMatchDtoBuilder> {
  @BuiltValueField(wireName: r'scoreFirst')
  num get scoreFirst;

  @BuiltValueField(wireName: r'scoreSecond')
  num get scoreSecond;

  TerminateMatchDto._();

  factory TerminateMatchDto([void updates(TerminateMatchDtoBuilder b)]) = _$TerminateMatchDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TerminateMatchDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TerminateMatchDto> get serializer => _$TerminateMatchDtoSerializer();
}

class _$TerminateMatchDtoSerializer implements PrimitiveSerializer<TerminateMatchDto> {
  @override
  final Iterable<Type> types = const [TerminateMatchDto, _$TerminateMatchDto];

  @override
  final String wireName = r'TerminateMatchDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TerminateMatchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'scoreFirst';
    yield serializers.serialize(
      object.scoreFirst,
      specifiedType: const FullType(num),
    );
    yield r'scoreSecond';
    yield serializers.serialize(
      object.scoreSecond,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TerminateMatchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TerminateMatchDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'scoreFirst':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.scoreFirst = valueDes;
          break;
        case r'scoreSecond':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.scoreSecond = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TerminateMatchDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TerminateMatchDtoBuilder();
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

