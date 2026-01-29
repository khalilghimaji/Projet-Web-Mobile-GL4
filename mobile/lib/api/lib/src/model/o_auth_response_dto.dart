// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'o_auth_response_dto.g.dart';

/// OAuthResponseDto
///
/// Properties:
/// * [accessToken] - JWT access token
/// * [refreshToken] - JWT refresh token
/// * [user] 
@BuiltValue()
abstract class OAuthResponseDto implements Built<OAuthResponseDto, OAuthResponseDtoBuilder> {
  /// JWT access token
  @BuiltValueField(wireName: r'accessToken')
  String? get accessToken;

  /// JWT refresh token
  @BuiltValueField(wireName: r'refreshToken')
  String? get refreshToken;

  @BuiltValueField(wireName: r'user')
  UserDto get user;

  OAuthResponseDto._();

  factory OAuthResponseDto([void updates(OAuthResponseDtoBuilder b)]) = _$OAuthResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OAuthResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OAuthResponseDto> get serializer => _$OAuthResponseDtoSerializer();
}

class _$OAuthResponseDtoSerializer implements PrimitiveSerializer<OAuthResponseDto> {
  @override
  final Iterable<Type> types = const [OAuthResponseDto, _$OAuthResponseDto];

  @override
  final String wireName = r'OAuthResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OAuthResponseDto object, {
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
    OAuthResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OAuthResponseDtoBuilder result,
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
  OAuthResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OAuthResponseDtoBuilder();
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


