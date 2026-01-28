// @dart=2.19
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'can_predict_match_dto.g.dart';

/// CanPredictMatchDto
///
/// Properties:
/// * [numberOfDiamondsBet] 
@BuiltValue()
abstract class CanPredictMatchDto implements Built<CanPredictMatchDto, CanPredictMatchDtoBuilder> {
  @BuiltValueField(wireName: r'numberOfDiamondsBet')
  num get numberOfDiamondsBet;

  CanPredictMatchDto._();

  factory CanPredictMatchDto([void updates(CanPredictMatchDtoBuilder b)]) = _$CanPredictMatchDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CanPredictMatchDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CanPredictMatchDto> get serializer => _$CanPredictMatchDtoSerializer();
}

class _$CanPredictMatchDtoSerializer implements PrimitiveSerializer<CanPredictMatchDto> {
  @override
  final Iterable<Type> types = const [CanPredictMatchDto, _$CanPredictMatchDto];

  @override
  final String wireName = r'CanPredictMatchDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CanPredictMatchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'numberOfDiamondsBet';
    yield serializers.serialize(
      object.numberOfDiamondsBet,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CanPredictMatchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CanPredictMatchDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'numberOfDiamondsBet':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.numberOfDiamondsBet = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CanPredictMatchDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CanPredictMatchDtoBuilder();
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

