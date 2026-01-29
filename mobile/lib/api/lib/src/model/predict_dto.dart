// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'predict_dto.g.dart';

/// PredictDto
///
/// Properties:
/// * [scoreFirst] 
/// * [scoreSecond] 
/// * [numberOfDiamondsBet] 
@BuiltValue()
abstract class PredictDto implements Built<PredictDto, PredictDtoBuilder> {
  @BuiltValueField(wireName: r'scoreFirst')
  num get scoreFirst;

  @BuiltValueField(wireName: r'scoreSecond')
  num get scoreSecond;

  @BuiltValueField(wireName: r'numberOfDiamondsBet')
  num get numberOfDiamondsBet;

  PredictDto._();

  factory PredictDto([void updates(PredictDtoBuilder b)]) = _$PredictDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PredictDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PredictDto> get serializer => _$PredictDtoSerializer();
}

class _$PredictDtoSerializer implements PrimitiveSerializer<PredictDto> {
  @override
  final Iterable<Type> types = const [PredictDto, _$PredictDto];

  @override
  final String wireName = r'PredictDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PredictDto object, {
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
    yield r'numberOfDiamondsBet';
    yield serializers.serialize(
      object.numberOfDiamondsBet,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PredictDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PredictDtoBuilder result,
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
  PredictDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PredictDtoBuilder();
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


