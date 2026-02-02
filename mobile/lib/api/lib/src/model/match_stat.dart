// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'match_stat.g.dart';

/// MatchStat
///
/// Properties:
/// * [totalVotes] 
/// * [homePercentage] 
/// * [drawPercentage] 
/// * [awayPercentage] 
/// * [voteEnabled] 
@BuiltValue()
abstract class MatchStat implements Built<MatchStat, MatchStatBuilder> {
  @BuiltValueField(wireName: r'totalVotes')
  num get totalVotes;

  @BuiltValueField(wireName: r'homePercentage')
  num get homePercentage;

  @BuiltValueField(wireName: r'drawPercentage')
  num get drawPercentage;

  @BuiltValueField(wireName: r'awayPercentage')
  num get awayPercentage;

  @BuiltValueField(wireName: r'voteEnabled')
  bool get voteEnabled;

  MatchStat._();

  factory MatchStat([void updates(MatchStatBuilder b)]) = _$MatchStat;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MatchStatBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MatchStat> get serializer => _$MatchStatSerializer();
}

class _$MatchStatSerializer implements PrimitiveSerializer<MatchStat> {
  @override
  final Iterable<Type> types = const [MatchStat, _$MatchStat];

  @override
  final String wireName = r'MatchStat';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MatchStat object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'totalVotes';
    yield serializers.serialize(
      object.totalVotes,
      specifiedType: const FullType(num),
    );
    yield r'homePercentage';
    yield serializers.serialize(
      object.homePercentage,
      specifiedType: const FullType(num),
    );
    yield r'drawPercentage';
    yield serializers.serialize(
      object.drawPercentage,
      specifiedType: const FullType(num),
    );
    yield r'awayPercentage';
    yield serializers.serialize(
      object.awayPercentage,
      specifiedType: const FullType(num),
    );
    yield r'voteEnabled';
    yield serializers.serialize(
      object.voteEnabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MatchStat object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MatchStatBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'totalVotes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.totalVotes = valueDes;
          break;
        case r'homePercentage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.homePercentage = valueDes;
          break;
        case r'drawPercentage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.drawPercentage = valueDes;
          break;
        case r'awayPercentage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.awayPercentage = valueDes;
          break;
        case r'voteEnabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.voteEnabled = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MatchStat deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MatchStatBuilder();
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


