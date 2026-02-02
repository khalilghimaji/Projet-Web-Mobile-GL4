# openapi.api.AuthenticationApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authControllerDisableMfa**](AuthenticationApi.md#authcontrollerdisablemfa) | **POST** /auth/mfa/disable | Disable MFA for user account
[**authControllerEnableMfa**](AuthenticationApi.md#authcontrollerenablemfa) | **POST** /auth/mfa/enable | Enable MFA for user account
[**authControllerForgotPassword**](AuthenticationApi.md#authcontrollerforgotpassword) | **POST** /auth/forgot-password | Request password reset email
[**authControllerGenerateMfaSecret**](AuthenticationApi.md#authcontrollergeneratemfasecret) | **GET** /auth/mfa/generate | Generate MFA secret and QR code
[**authControllerGetProfile**](AuthenticationApi.md#authcontrollergetprofile) | **GET** /auth/profile | Get authenticated user profile
[**authControllerGithubAuth**](AuthenticationApi.md#authcontrollergithubauth) | **GET** /auth/github | Initiate GitHub OAuth login flow
[**authControllerGithubAuthCallback**](AuthenticationApi.md#authcontrollergithubauthcallback) | **GET** /auth/github/callback | Handle GitHub OAuth callback
[**authControllerGoogleAuth**](AuthenticationApi.md#authcontrollergoogleauth) | **GET** /auth/google | Initiate Google OAuth login flow
[**authControllerGoogleAuthCallback**](AuthenticationApi.md#authcontrollergoogleauthcallback) | **GET** /auth/google/callback | Handle Google OAuth callback
[**authControllerLogin**](AuthenticationApi.md#authcontrollerlogin) | **POST** /auth/login | User login
[**authControllerLoginWithFirebase**](AuthenticationApi.md#authcontrollerloginwithfirebase) | **POST** /auth/login/firebase | User login with Firebase
[**authControllerLogout**](AuthenticationApi.md#authcontrollerlogout) | **POST** /auth/logout | User logout
[**authControllerRefreshToken**](AuthenticationApi.md#authcontrollerrefreshtoken) | **POST** /auth/refresh | Refresh access token
[**authControllerResetPassword**](AuthenticationApi.md#authcontrollerresetpassword) | **POST** /auth/reset-password | Reset password with token
[**authControllerSignUp**](AuthenticationApi.md#authcontrollersignup) | **POST** /auth/signup | Register a new user
[**authControllerVerifyEmail**](AuthenticationApi.md#authcontrollerverifyemail) | **POST** /auth/verify-email | Verify user email address
[**authControllerVerifyMfaToken**](AuthenticationApi.md#authcontrollerverifymfatoken) | **POST** /auth/mfa/verify | Verify MFA code during login


# **authControllerDisableMfa**
> MfaDisableResponseDto authControllerDisableMfa(disableMfaDto)

Disable MFA for user account

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();
final DisableMfaDto disableMfaDto = ; // DisableMfaDto | 

try {
    final response = api.authControllerDisableMfa(disableMfaDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerDisableMfa: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **disableMfaDto** | [**DisableMfaDto**](DisableMfaDto.md)|  | 

### Return type

[**MfaDisableResponseDto**](MfaDisableResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerEnableMfa**
> MfaEnableResponseDto authControllerEnableMfa(mfaEnableDto)

Enable MFA for user account

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();
final MfaEnableDto mfaEnableDto = ; // MfaEnableDto | 

try {
    final response = api.authControllerEnableMfa(mfaEnableDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerEnableMfa: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mfaEnableDto** | [**MfaEnableDto**](MfaEnableDto.md)|  | 

### Return type

[**MfaEnableResponseDto**](MfaEnableResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerForgotPassword**
> ForgotPasswordResponseDto authControllerForgotPassword(forgotPasswordDto)

Request password reset email

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();
final ForgotPasswordDto forgotPasswordDto = ; // ForgotPasswordDto | 

try {
    final response = api.authControllerForgotPassword(forgotPasswordDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerForgotPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **forgotPasswordDto** | [**ForgotPasswordDto**](ForgotPasswordDto.md)|  | 

### Return type

[**ForgotPasswordResponseDto**](ForgotPasswordResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerGenerateMfaSecret**
> MfaGenerateResponseDto authControllerGenerateMfaSecret()

Generate MFA secret and QR code

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();

try {
    final response = api.authControllerGenerateMfaSecret();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerGenerateMfaSecret: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MfaGenerateResponseDto**](MfaGenerateResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerGetProfile**
> UserDto authControllerGetProfile()

Get authenticated user profile

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();

try {
    final response = api.authControllerGetProfile();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerGetProfile: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserDto**](UserDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerGithubAuth**
> authControllerGithubAuth()

Initiate GitHub OAuth login flow

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();

try {
    api.authControllerGithubAuth();
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerGithubAuth: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerGithubAuthCallback**
> OAuthResponseDto authControllerGithubAuthCallback()

Handle GitHub OAuth callback

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();

try {
    final response = api.authControllerGithubAuthCallback();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerGithubAuthCallback: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**OAuthResponseDto**](OAuthResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerGoogleAuth**
> authControllerGoogleAuth()

Initiate Google OAuth login flow

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();

try {
    api.authControllerGoogleAuth();
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerGoogleAuth: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerGoogleAuthCallback**
> OAuthResponseDto authControllerGoogleAuthCallback()

Handle Google OAuth callback

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();

try {
    final response = api.authControllerGoogleAuthCallback();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerGoogleAuthCallback: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**OAuthResponseDto**](OAuthResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerLogin**
> LoginResponseDto authControllerLogin(loginDto)

User login

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();
final LoginDto loginDto = ; // LoginDto | 

try {
    final response = api.authControllerLogin(loginDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginDto** | [**LoginDto**](LoginDto.md)|  | 

### Return type

[**LoginResponseDto**](LoginResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerLoginWithFirebase**
> LoginResponseDto authControllerLoginWithFirebase(firebaseLoginDto)

User login with Firebase

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();
final FirebaseLoginDto firebaseLoginDto = ; // FirebaseLoginDto | 

try {
    final response = api.authControllerLoginWithFirebase(firebaseLoginDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerLoginWithFirebase: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **firebaseLoginDto** | [**FirebaseLoginDto**](FirebaseLoginDto.md)|  | 

### Return type

[**LoginResponseDto**](LoginResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerLogout**
> LogoutResponseDto authControllerLogout()

User logout

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();

try {
    final response = api.authControllerLogout();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerLogout: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**LogoutResponseDto**](LogoutResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerRefreshToken**
> RefresResponse authControllerRefreshToken()

Refresh access token

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();

try {
    final response = api.authControllerRefreshToken();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerRefreshToken: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RefresResponse**](RefresResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerResetPassword**
> ResetPasswordResponseDto authControllerResetPassword(resetPasswordDto)

Reset password with token

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();
final ResetPasswordDto resetPasswordDto = ; // ResetPasswordDto | 

try {
    final response = api.authControllerResetPassword(resetPasswordDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerResetPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **resetPasswordDto** | [**ResetPasswordDto**](ResetPasswordDto.md)|  | 

### Return type

[**ResetPasswordResponseDto**](ResetPasswordResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerSignUp**
> SignUpResponseDto authControllerSignUp(firstName, lastName, email, password, imageUrl)

Register a new user

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();
final String firstName = firstName_example; // String | 
final String lastName = lastName_example; // String | 
final String email = email_example; // String | 
final String password = password_example; // String | 
final MultipartFile imageUrl = BINARY_DATA_HERE; // MultipartFile | 

try {
    final response = api.authControllerSignUp(firstName, lastName, email, password, imageUrl);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerSignUp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **firstName** | **String**|  | 
 **lastName** | **String**|  | 
 **email** | **String**|  | 
 **password** | **String**|  | 
 **imageUrl** | **MultipartFile**|  | [optional] 

### Return type

[**SignUpResponseDto**](SignUpResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerVerifyEmail**
> VerifyEmailResponseDto authControllerVerifyEmail(verifyEmailDto)

Verify user email address

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();
final VerifyEmailDto verifyEmailDto = ; // VerifyEmailDto | 

try {
    final response = api.authControllerVerifyEmail(verifyEmailDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerVerifyEmail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **verifyEmailDto** | [**VerifyEmailDto**](VerifyEmailDto.md)|  | 

### Return type

[**VerifyEmailResponseDto**](VerifyEmailResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerVerifyMfaToken**
> MfaVerifyResponseDto authControllerVerifyMfaToken(mfaVerifyDto)

Verify MFA code during login

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();
final MfaVerifyDto mfaVerifyDto = ; // MfaVerifyDto | 

try {
    final response = api.authControllerVerifyMfaToken(mfaVerifyDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authControllerVerifyMfaToken: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mfaVerifyDto** | [**MfaVerifyDto**](MfaVerifyDto.md)|  | 

### Return type

[**MfaVerifyResponseDto**](MfaVerifyResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

