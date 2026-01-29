// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_data_any_of1_rankings_inner.g.dart';

/// NotificationDataAnyOf1RankingsInner
///
/// Properties:
/// * [firstName] 
/// * [lastName] 
/// * [score] 
/// * [imageUrl] 
@BuiltValue()
abstract class NotificationDataAnyOf1RankingsInner implements Built<NotificationDataAnyOf1RankingsInner, NotificationDataAnyOf1RankingsInnerBuilder> {
  @BuiltValueField(wireName: r'firstName')
  String? get firstName;

  @BuiltValueField(wireName: r'lastName')
  String? get lastName;

  @BuiltValueField(wireName: r'score')
  num? get score;

  @BuiltValueField(wireName: r'imageUrl')
  String? get imageUrl;

  NotificationDataAnyOf1RankingsInner._();

  factory NotificationDataAnyOf1RankingsInner([void updates(NotificationDataAnyOf1RankingsInnerBuilder b)]) = _$NotificationDataAnyOf1RankingsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationDataAnyOf1RankingsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationDataAnyOf1RankingsInner> get serializer => _$NotificationDataAnyOf1RankingsInnerSerializer();
}

class _$NotificationDataAnyOf1RankingsInnerSerializer implements PrimitiveSerializer<NotificationDataAnyOf1RankingsInner> {
  @override
  final Iterable<Type> types = const [NotificationDataAnyOf1RankingsInner, _$NotificationDataAnyOf1RankingsInner];

  @override
  final String wireName = r'NotificationDataAnyOf1RankingsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationDataAnyOf1RankingsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.firstName != null) {
      yield r'firstName';
      yield serializers.serialize(
        object.firstName,
        specifiedType: const FullType(String),
      );
    }
    if (object.lastName != null) {
      yield r'lastName';
      yield serializers.serialize(
        object.lastName,
        specifiedType: const FullType(String),
      );
    }
    if (object.score != null) {
      yield r'score';
      yield serializers.serialize(
        object.score,
        specifiedType: const FullType(num),
      );
    }
    if (object.imageUrl != null) {
      yield r'imageUrl';
      yield serializers.serialize(
        object.imageUrl,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationDataAnyOf1RankingsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationDataAnyOf1RankingsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'firstName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstName = valueDes;
          break;
        case r'lastName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lastName = valueDes;
          break;
        case r'score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.score = valueDes;
          break;
        case r'imageUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.imageUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationDataAnyOf1RankingsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationDataAnyOf1RankingsInnerBuilder();
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


