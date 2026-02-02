// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'prediction.g.dart';

/// Prediction
///
/// Properties:
/// * [user] 
/// * [userId] 
/// * [matchId] 
/// * [scoreFirstEquipe] 
/// * [scoreSecondEquipe] 
/// * [numberOfDiamondsBet] 
/// * [pointsEarned] 
/// * [id] 
/// * [createdAt] 
/// * [updatedAt] 
/// * [version] 
@BuiltValue()
abstract class Prediction implements Built<Prediction, PredictionBuilder> {
  @BuiltValueField(wireName: r'user')
  User get user;

  @BuiltValueField(wireName: r'userId')
  String get userId;

  @BuiltValueField(wireName: r'matchId')
  String get matchId;

  @BuiltValueField(wireName: r'scoreFirstEquipe')
  num get scoreFirstEquipe;

  @BuiltValueField(wireName: r'scoreSecondEquipe')
  num get scoreSecondEquipe;

  @BuiltValueField(wireName: r'numberOfDiamondsBet')
  num get numberOfDiamondsBet;

  @BuiltValueField(wireName: r'pointsEarned')
  num get pointsEarned;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'version')
  num get version;

  Prediction._();

  factory Prediction([void updates(PredictionBuilder b)]) = _$Prediction;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PredictionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Prediction> get serializer => _$PredictionSerializer();
}

class _$PredictionSerializer implements PrimitiveSerializer<Prediction> {
  @override
  final Iterable<Type> types = const [Prediction, _$Prediction];

  @override
  final String wireName = r'Prediction';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Prediction object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(User),
    );
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
    yield r'matchId';
    yield serializers.serialize(
      object.matchId,
      specifiedType: const FullType(String),
    );
    yield r'scoreFirstEquipe';
    yield serializers.serialize(
      object.scoreFirstEquipe,
      specifiedType: const FullType(num),
    );
    yield r'scoreSecondEquipe';
    yield serializers.serialize(
      object.scoreSecondEquipe,
      specifiedType: const FullType(num),
    );
    yield r'numberOfDiamondsBet';
    yield serializers.serialize(
      object.numberOfDiamondsBet,
      specifiedType: const FullType(num),
    );
    yield r'pointsEarned';
    yield serializers.serialize(
      object.pointsEarned,
      specifiedType: const FullType(num),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Prediction object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PredictionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(User),
          ) as User;
          result.user.replace(valueDes);
          break;
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        case r'matchId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.matchId = valueDes;
          break;
        case r'scoreFirstEquipe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.scoreFirstEquipe = valueDes;
          break;
        case r'scoreSecondEquipe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.scoreSecondEquipe = valueDes;
          break;
        case r'numberOfDiamondsBet':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.numberOfDiamondsBet = valueDes;
          break;
        case r'pointsEarned':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.pointsEarned = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Prediction deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PredictionBuilder();
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


