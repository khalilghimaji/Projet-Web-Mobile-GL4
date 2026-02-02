// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'firebase_login_dto.g.dart';

/// FirebaseLoginDto
///
/// Properties:
/// * [firebaseToken] 
@BuiltValue()
abstract class FirebaseLoginDto implements Built<FirebaseLoginDto, FirebaseLoginDtoBuilder> {
  @BuiltValueField(wireName: r'firebaseToken')
  String get firebaseToken;

  FirebaseLoginDto._();

  factory FirebaseLoginDto([void updates(FirebaseLoginDtoBuilder b)]) = _$FirebaseLoginDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FirebaseLoginDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FirebaseLoginDto> get serializer => _$FirebaseLoginDtoSerializer();
}

class _$FirebaseLoginDtoSerializer implements PrimitiveSerializer<FirebaseLoginDto> {
  @override
  final Iterable<Type> types = const [FirebaseLoginDto, _$FirebaseLoginDto];

  @override
  final String wireName = r'FirebaseLoginDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FirebaseLoginDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'firebaseToken';
    yield serializers.serialize(
      object.firebaseToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FirebaseLoginDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FirebaseLoginDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'firebaseToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firebaseToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FirebaseLoginDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FirebaseLoginDtoBuilder();
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


