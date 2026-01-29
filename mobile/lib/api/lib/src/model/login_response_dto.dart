// @dart=3.9
// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'login_response_dto.g.dart';

/// LoginResponseDto
///
/// Properties:
/// * [accessToken] - JWT access token
/// * [refreshToken] - JWT refresh token
/// * [user]
/// * [message] - Message indicating MFA verification is required
/// * [mfaToken] - Temporary token for MFA verification
/// * [isMfaRequired] - Flag indicating MFA is required
@BuiltValue()
abstract class LoginResponseDto
    implements Built<LoginResponseDto, LoginResponseDtoBuilder> {
  /// JWT access token
  @BuiltValueField(wireName: r'accessToken')
  String? get accessToken;

  /// JWT refresh token
  @BuiltValueField(wireName: r'refreshToken')
  String? get refreshToken;

  @BuiltValueField(wireName: r'user')
  UserDto? get user;

  /// Message indicating MFA verification is required
  @BuiltValueField(wireName: r'message')
  String? get message;

  /// Temporary token for MFA verification
  @BuiltValueField(wireName: r'mfaToken')
  String? get mfaToken;

  /// Flag indicating MFA is required
  @BuiltValueField(wireName: r'isMfaRequired')
  bool? get isMfaRequired;

  LoginResponseDto._();

  factory LoginResponseDto([void updates(LoginResponseDtoBuilder b)]) =
      _$LoginResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoginResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoginResponseDto> get serializer =>
      _$LoginResponseDtoSerializer();
}

class _$LoginResponseDtoSerializer
    implements PrimitiveSerializer<LoginResponseDto> {
  @override
  final Iterable<Type> types = const [LoginResponseDto, _$LoginResponseDto];

  @override
  final String wireName = r'LoginResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoginResponseDto object, {
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
    if (object.user != null) {
      yield r'user';
      yield serializers.serialize(
        object.user,
        specifiedType: const FullType(UserDto),
      );
    }
    if (object.message != null) {
      yield r'message';
      yield serializers.serialize(
        object.message,
        specifiedType: const FullType(String),
      );
    }
    if (object.mfaToken != null) {
      yield r'mfaToken';
      yield serializers.serialize(
        object.mfaToken,
        specifiedType: const FullType(String),
      );
    }
    if (object.isMfaRequired != null) {
      yield r'isMfaRequired';
      yield serializers.serialize(
        object.isMfaRequired,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LoginResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoginResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accessToken':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.accessToken = valueDes;
          break;
        case r'refreshToken':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.refreshToken = valueDes;
          break;
        case r'user':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(UserDto),
                  )
                  as UserDto;
          result.user.replace(valueDes);
          break;
        case r'message':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.message = valueDes;
          break;
        case r'mfaToken':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.mfaToken = valueDes;
          break;
        case r'isMfaRequired':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.isMfaRequired = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoginResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoginResponseDtoBuilder();
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
