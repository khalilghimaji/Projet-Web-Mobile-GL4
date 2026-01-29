// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'refres_response.g.dart';

/// RefresResponse
///
/// Properties:
/// * [message] 
@BuiltValue()
abstract class RefresResponse implements Built<RefresResponse, RefresResponseBuilder> {
  @BuiltValueField(wireName: r'message')
  String get message;

  RefresResponse._();

  factory RefresResponse([void updates(RefresResponseBuilder b)]) = _$RefresResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RefresResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RefresResponse> get serializer => _$RefresResponseSerializer();
}

class _$RefresResponseSerializer implements PrimitiveSerializer<RefresResponse> {
  @override
  final Iterable<Type> types = const [RefresResponse, _$RefresResponse];

  @override
  final String wireName = r'RefresResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RefresResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RefresResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RefresResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RefresResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RefresResponseBuilder();
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


