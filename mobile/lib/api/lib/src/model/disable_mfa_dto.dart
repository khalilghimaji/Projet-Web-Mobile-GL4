// @dart=2.19
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'disable_mfa_dto.g.dart';

/// DisableMfaDto
///
/// Properties:
/// * [password] 
@BuiltValue()
abstract class DisableMfaDto implements Built<DisableMfaDto, DisableMfaDtoBuilder> {
  @BuiltValueField(wireName: r'password')
  String get password;

  DisableMfaDto._();

  factory DisableMfaDto([void updates(DisableMfaDtoBuilder b)]) = _$DisableMfaDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisableMfaDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisableMfaDto> get serializer => _$DisableMfaDtoSerializer();
}

class _$DisableMfaDtoSerializer implements PrimitiveSerializer<DisableMfaDto> {
  @override
  final Iterable<Type> types = const [DisableMfaDto, _$DisableMfaDto];

  @override
  final String wireName = r'DisableMfaDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisableMfaDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisableMfaDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisableMfaDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisableMfaDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisableMfaDtoBuilder();
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

