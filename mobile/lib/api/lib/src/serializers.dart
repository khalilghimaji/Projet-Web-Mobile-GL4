// @dart=3.9
//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:openapi/src/date_serializer.dart';
import 'package:openapi/src/model/date.dart';

import 'package:openapi/src/model/can_predict_match_dto.dart';
import 'package:openapi/src/model/disable_mfa_dto.dart';
import 'package:openapi/src/model/firebase_login_dto.dart';
import 'package:openapi/src/model/forgot_password_dto.dart';
import 'package:openapi/src/model/forgot_password_response_dto.dart';
import 'package:openapi/src/model/login_dto.dart';
import 'package:openapi/src/model/login_response_dto.dart';
import 'package:openapi/src/model/logout_response_dto.dart';
import 'package:openapi/src/model/match_stat.dart';
import 'package:openapi/src/model/mfa_disable_response_dto.dart';
import 'package:openapi/src/model/mfa_enable_dto.dart';
import 'package:openapi/src/model/mfa_enable_response_dto.dart';
import 'package:openapi/src/model/mfa_generate_response_dto.dart';
import 'package:openapi/src/model/mfa_verify_dto.dart';
import 'package:openapi/src/model/mfa_verify_response_dto.dart';
import 'package:openapi/src/model/notification.dart';
import 'package:openapi/src/model/notification_data.dart';
import 'package:openapi/src/model/notification_data_any_of.dart';
import 'package:openapi/src/model/notification_data_any_of1.dart';
import 'package:openapi/src/model/notification_data_any_of1_rankings_inner.dart';
import 'package:openapi/src/model/o_auth_response_dto.dart';
import 'package:openapi/src/model/predict_dto.dart';
import 'package:openapi/src/model/prediction.dart';
import 'package:openapi/src/model/refres_response.dart';
import 'package:openapi/src/model/reset_password_dto.dart';
import 'package:openapi/src/model/reset_password_response_dto.dart';
import 'package:openapi/src/model/sign_up_response_dto.dart';
import 'package:openapi/src/model/terminate_match_dto.dart';
import 'package:openapi/src/model/update_prediction_dto.dart';
import 'package:openapi/src/model/user.dart';
import 'package:openapi/src/model/user_dto.dart';
import 'package:openapi/src/model/verify_email_dto.dart';
import 'package:openapi/src/model/verify_email_response_dto.dart';

part 'serializers.g.dart';

@SerializersFor([
  CanPredictMatchDto,
  DisableMfaDto,
  FirebaseLoginDto,
  ForgotPasswordDto,
  ForgotPasswordResponseDto,
  LoginDto,
  LoginResponseDto,
  LogoutResponseDto,
  MatchStat,
  MfaDisableResponseDto,
  MfaEnableDto,
  MfaEnableResponseDto,
  MfaGenerateResponseDto,
  MfaVerifyDto,
  MfaVerifyResponseDto,
  Notification,
  NotificationData,
  NotificationDataAnyOf,
  NotificationDataAnyOf1,
  NotificationDataAnyOf1RankingsInner,
  OAuthResponseDto,
  PredictDto,
  Prediction,
  RefresResponse,
  ResetPasswordDto,
  ResetPasswordResponseDto,
  SignUpResponseDto,
  TerminateMatchDto,
  UpdatePredictionDto,
  User,
  UserDto,
  VerifyEmailDto,
  VerifyEmailResponseDto,
])
Serializers serializers =
    (_$serializers.toBuilder()
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(Notification)]),
            () => ListBuilder<Notification>(),
          )
          ..add(const OneOfSerializer())
          ..add(const AnyOfSerializer())
          ..add(const DateSerializer())
          ..add(Iso8601DateTimeSerializer()))
        .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
