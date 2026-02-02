# openapi.model.LoginResponseDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**accessToken** | **String** | JWT access token | [optional] 
**refreshToken** | **String** | JWT refresh token | [optional] 
**user** | [**UserDto**](UserDto.md) |  | [optional] 
**message** | **String** | Message indicating MFA verification is required | [optional] 
**mfaToken** | **String** | Temporary token for MFA verification | [optional] 
**isMfaRequired** | **bool** | Flag indicating MFA is required | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


