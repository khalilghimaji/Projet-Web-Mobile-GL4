// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/notification_data_any_of1_rankings_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_data_any_of1.g.dart';

/// NotificationDataAnyOf1
///
/// Properties:
/// * [rankings] 
@BuiltValue()
abstract class NotificationDataAnyOf1 implements Built<NotificationDataAnyOf1, NotificationDataAnyOf1Builder> {
  @BuiltValueField(wireName: r'rankings')
  BuiltList<NotificationDataAnyOf1RankingsInner>? get rankings;

  NotificationDataAnyOf1._();

  factory NotificationDataAnyOf1([void updates(NotificationDataAnyOf1Builder b)]) = _$NotificationDataAnyOf1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationDataAnyOf1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationDataAnyOf1> get serializer => _$NotificationDataAnyOf1Serializer();
}

class _$NotificationDataAnyOf1Serializer implements PrimitiveSerializer<NotificationDataAnyOf1> {
  @override
  final Iterable<Type> types = const [NotificationDataAnyOf1, _$NotificationDataAnyOf1];

  @override
  final String wireName = r'NotificationDataAnyOf1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationDataAnyOf1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.rankings != null) {
      yield r'rankings';
      yield serializers.serialize(
        object.rankings,
        specifiedType: const FullType(BuiltList, [FullType(NotificationDataAnyOf1RankingsInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationDataAnyOf1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationDataAnyOf1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rankings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(NotificationDataAnyOf1RankingsInner)]),
          ) as BuiltList<NotificationDataAnyOf1RankingsInner>;
          result.rankings.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationDataAnyOf1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationDataAnyOf1Builder();
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


