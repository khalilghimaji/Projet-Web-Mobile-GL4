# openapi.api.TestApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**testControllerAddDiamond**](TestApi.md#testcontrolleradddiamond) | **POST** /test/{userId}/add-diamond | 
[**testControllerEndMatch**](TestApi.md#testcontrollerendmatch) | **POST** /test/{id}/end-match | 
[**testControllerMakePrediction**](TestApi.md#testcontrollermakeprediction) | **POST** /test/{userId}/{matchId}/predict | 
[**testControllerUpdateMatch**](TestApi.md#testcontrollerupdatematch) | **POST** /test/{id}/update-match | 


# **testControllerAddDiamond**
> testControllerAddDiamond(userId, canPredictMatchDto)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTestApi();
final String userId = userId_example; // String | 
final CanPredictMatchDto canPredictMatchDto = ; // CanPredictMatchDto | 

try {
    api.testControllerAddDiamond(userId, canPredictMatchDto);
} on DioException catch (e) {
    print('Exception when calling TestApi->testControllerAddDiamond: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **canPredictMatchDto** | [**CanPredictMatchDto**](CanPredictMatchDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **testControllerEndMatch**
> testControllerEndMatch(id, terminateMatchDto)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTestApi();
final String id = id_example; // String | 
final TerminateMatchDto terminateMatchDto = ; // TerminateMatchDto | 

try {
    api.testControllerEndMatch(id, terminateMatchDto);
} on DioException catch (e) {
    print('Exception when calling TestApi->testControllerEndMatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **terminateMatchDto** | [**TerminateMatchDto**](TerminateMatchDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **testControllerMakePrediction**
> Prediction testControllerMakePrediction(userId, matchId, predictDto)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTestApi();
final String userId = userId_example; // String | 
final String matchId = matchId_example; // String | 
final PredictDto predictDto = ; // PredictDto | 

try {
    final response = api.testControllerMakePrediction(userId, matchId, predictDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TestApi->testControllerMakePrediction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **matchId** | **String**|  | 
 **predictDto** | [**PredictDto**](PredictDto.md)|  | 

### Return type

[**Prediction**](Prediction.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **testControllerUpdateMatch**
> testControllerUpdateMatch(id, terminateMatchDto)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTestApi();
final String id = id_example; // String | 
final TerminateMatchDto terminateMatchDto = ; // TerminateMatchDto | 

try {
    api.testControllerUpdateMatch(id, terminateMatchDto);
} on DioException catch (e) {
    print('Exception when calling TestApi->testControllerUpdateMatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **terminateMatchDto** | [**TerminateMatchDto**](TerminateMatchDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

