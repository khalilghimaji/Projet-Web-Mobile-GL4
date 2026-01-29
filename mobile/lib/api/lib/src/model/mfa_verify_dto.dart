// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_verify_dto.g.dart';

/// MfaVerifyDto
///
/// Properties:
/// * [code] 
/// * [rememberMe] 
@BuiltValue()
abstract class MfaVerifyDto implements Built<MfaVerifyDto, MfaVerifyDtoBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'rememberMe')
  bool? get rememberMe;

  MfaVerifyDto._();

  factory MfaVerifyDto([void updates(MfaVerifyDtoBuilder b)]) = _$MfaVerifyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaVerifyDtoBuilder b) => b
      ..rememberMe = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaVerifyDto> get serializer => _$MfaVerifyDtoSerializer();
}

class _$MfaVerifyDtoSerializer implements PrimitiveSerializer<MfaVerifyDto> {
  @override
  final Iterable<Type> types = const [MfaVerifyDto, _$MfaVerifyDto];

  @override
  final String wireName = r'MfaVerifyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaVerifyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    if (object.rememberMe != null) {
      yield r'rememberMe';
      yield serializers.serialize(
        object.rememberMe,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaVerifyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaVerifyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'rememberMe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.rememberMe = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaVerifyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaVerifyDtoBuilder();
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


