// @dart=2.19
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/notification_data_any_of1_rankings_inner.dart';
import 'package:openapi/src/model/notification_data_any_of.dart';
import 'package:openapi/src/model/notification_data_any_of1.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/any_of.dart';

part 'notification_data.g.dart';

/// Additional data for the notification
///
/// Properties:
/// * [gain] 
/// * [newDiamonds] 
/// * [rankings] 
@BuiltValue()
abstract class NotificationData implements Built<NotificationData, NotificationDataBuilder> {
  /// Any Of [NotificationDataAnyOf], [NotificationDataAnyOf1]
  AnyOf get anyOf;

  NotificationData._();

  factory NotificationData([void updates(NotificationDataBuilder b)]) = _$NotificationData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationData> get serializer => _$NotificationDataSerializer();
}

class _$NotificationDataSerializer implements PrimitiveSerializer<NotificationData> {
  @override
  final Iterable<Type> types = const [NotificationData, _$NotificationData];

  @override
  final String wireName = r'NotificationData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final anyOf = object.anyOf;
    return serializers.serialize(anyOf, specifiedType: FullType(AnyOf, anyOf.valueTypes.map((type) => FullType(type)).toList()))!;
  }

  @override
  NotificationData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationDataBuilder();
    Object? anyOfDataSrc;
    final targetType = const FullType(AnyOf, [FullType(NotificationDataAnyOf), FullType(NotificationDataAnyOf1), ]);
    anyOfDataSrc = serialized;
    result.anyOf = serializers.deserialize(anyOfDataSrc, specifiedType: targetType) as AnyOf;
    return result.build();
  }
}

