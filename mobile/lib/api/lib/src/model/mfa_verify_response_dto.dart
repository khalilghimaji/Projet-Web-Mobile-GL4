// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_verify_response_dto.g.dart';

/// MfaVerifyResponseDto
///
/// Properties:
/// * [accessToken] - JWT access token
/// * [refreshToken] - JWT refresh token
/// * [user] 
@BuiltValue()
abstract class MfaVerifyResponseDto implements Built<MfaVerifyResponseDto, MfaVerifyResponseDtoBuilder> {
  /// JWT access token
  @BuiltValueField(wireName: r'accessToken')
  String? get accessToken;

  /// JWT refresh token
  @BuiltValueField(wireName: r'refreshToken')
  String? get refreshToken;

  @BuiltValueField(wireName: r'user')
  UserDto get user;

  MfaVerifyResponseDto._();

  factory MfaVerifyResponseDto([void updates(MfaVerifyResponseDtoBuilder b)]) = _$MfaVerifyResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaVerifyResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaVerifyResponseDto> get serializer => _$MfaVerifyResponseDtoSerializer();
}

class _$MfaVerifyResponseDtoSerializer implements PrimitiveSerializer<MfaVerifyResponseDto> {
  @override
  final Iterable<Type> types = const [MfaVerifyResponseDto, _$MfaVerifyResponseDto];

  @override
  final String wireName = r'MfaVerifyResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaVerifyResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.accessToken != null) {
      yield r'accessToken';
      yield serializers.serialize(
        object.accessToken,
        specifiedType: const FullType(String),
      );
    }
    if (object.refreshToken != null) {
      yield r'refreshToken';
      yield serializers.serialize(
        object.refreshToken,
        specifiedType: const FullType(String),
      );
    }
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaVerifyResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaVerifyResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accessToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accessToken = valueDes;
          break;
        case r'refreshToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refreshToken = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserDto),
          ) as UserDto;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaVerifyResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaVerifyResponseDtoBuilder();
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


