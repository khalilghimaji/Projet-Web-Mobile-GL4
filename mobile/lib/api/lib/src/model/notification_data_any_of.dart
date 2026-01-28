// @dart=2.19
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_data_any_of.g.dart';

/// NotificationDataAnyOf
///
/// Properties:
/// * [gain] 
/// * [newDiamonds] 
@BuiltValue()
abstract class NotificationDataAnyOf implements Built<NotificationDataAnyOf, NotificationDataAnyOfBuilder> {
  @BuiltValueField(wireName: r'gain')
  num? get gain;

  @BuiltValueField(wireName: r'newDiamonds')
  num? get newDiamonds;

  NotificationDataAnyOf._();

  factory NotificationDataAnyOf([void updates(NotificationDataAnyOfBuilder b)]) = _$NotificationDataAnyOf;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationDataAnyOfBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationDataAnyOf> get serializer => _$NotificationDataAnyOfSerializer();
}

class _$NotificationDataAnyOfSerializer implements PrimitiveSerializer<NotificationDataAnyOf> {
  @override
  final Iterable<Type> types = const [NotificationDataAnyOf, _$NotificationDataAnyOf];

  @override
  final String wireName = r'NotificationDataAnyOf';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationDataAnyOf object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.gain != null) {
      yield r'gain';
      yield serializers.serialize(
        object.gain,
        specifiedType: const FullType(num),
      );
    }
    if (object.newDiamonds != null) {
      yield r'newDiamonds';
      yield serializers.serialize(
        object.newDiamonds,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationDataAnyOf object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationDataAnyOfBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'gain':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.gain = valueDes;
          break;
        case r'newDiamonds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.newDiamonds = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationDataAnyOf deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationDataAnyOfBuilder();
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

