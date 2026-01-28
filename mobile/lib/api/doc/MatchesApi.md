# openapi.api.MatchesApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**matchesControllerAddDiamond**](MatchesApi.md#matchescontrolleradddiamond) | **POST** /matches/add-diamond | 
[**matchesControllerCanPredict**](MatchesApi.md#matchescontrollercanpredict) | **POST** /matches/can-predict/{id} | 
[**matchesControllerEndMatch**](MatchesApi.md#matchescontrollerendmatch) | **POST** /matches/{id}/end-match | 
[**matchesControllerGetPredictionsStatsForMatch**](MatchesApi.md#matchescontrollergetpredictionsstatsformatch) | **GET** /matches/match-stats-info/{id} | 
[**matchesControllerGetUserGains**](MatchesApi.md#matchescontrollergetusergains) | **GET** /matches/user/gains | 
[**matchesControllerGetUserPrediction**](MatchesApi.md#matchescontrollergetuserprediction) | **GET** /matches/{id}/prediction | 
[**matchesControllerMakePrediction**](MatchesApi.md#matchescontrollermakeprediction) | **POST** /matches/{id}/predict | 
[**matchesControllerUpdateMatch**](MatchesApi.md#matchescontrollerupdatematch) | **POST** /matches/{id}/update-match | 
[**matchesControllerUpdatePrediction**](MatchesApi.md#matchescontrollerupdateprediction) | **PATCH** /matches/{id}/prediction | 


# **matchesControllerAddDiamond**
> matchesControllerAddDiamond(canPredictMatchDto)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getMatchesApi();
final CanPredictMatchDto canPredictMatchDto = ; // CanPredictMatchDto | 

try {
    api.matchesControllerAddDiamond(canPredictMatchDto);
} on DioException catch (e) {
    print('Exception when calling MatchesApi->matchesControllerAddDiamond: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **canPredictMatchDto** | [**CanPredictMatchDto**](CanPredictMatchDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **matchesControllerCanPredict**
> bool matchesControllerCanPredict(id, canPredictMatchDto)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getMatchesApi();
final String id = id_example; // String | 
final CanPredictMatchDto canPredictMatchDto = ; // CanPredictMatchDto | 

try {
    final response = api.matchesControllerCanPredict(id, canPredictMatchDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MatchesApi->matchesControllerCanPredict: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **canPredictMatchDto** | [**CanPredictMatchDto**](CanPredictMatchDto.md)|  | 

### Return type

**bool**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **matchesControllerEndMatch**
> matchesControllerEndMatch(id, terminateMatchDto)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getMatchesApi();
final String id = id_example; // String | 
final TerminateMatchDto terminateMatchDto = ; // TerminateMatchDto | 

try {
    api.matchesControllerEndMatch(id, terminateMatchDto);
} on DioException catch (e) {
    print('Exception when calling MatchesApi->matchesControllerEndMatch: $e\n');
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

# **matchesControllerGetPredictionsStatsForMatch**
> MatchStat matchesControllerGetPredictionsStatsForMatch(id)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getMatchesApi();
final String id = id_example; // String | 

try {
    final response = api.matchesControllerGetPredictionsStatsForMatch(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MatchesApi->matchesControllerGetPredictionsStatsForMatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**MatchStat**](MatchStat.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **matchesControllerGetUserGains**
> num matchesControllerGetUserGains()



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getMatchesApi();

try {
    final response = api.matchesControllerGetUserGains();
    print(response);
} on DioException catch (e) {
    print('Exception when calling MatchesApi->matchesControllerGetUserGains: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**num**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **matchesControllerGetUserPrediction**
> JsonObject matchesControllerGetUserPrediction(id)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getMatchesApi();
final String id = id_example; // String | 

try {
    final response = api.matchesControllerGetUserPrediction(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MatchesApi->matchesControllerGetUserPrediction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **matchesControllerMakePrediction**
> Prediction matchesControllerMakePrediction(id, predictDto)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getMatchesApi();
final String id = id_example; // String | 
final PredictDto predictDto = ; // PredictDto | 

try {
    final response = api.matchesControllerMakePrediction(id, predictDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MatchesApi->matchesControllerMakePrediction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **predictDto** | [**PredictDto**](PredictDto.md)|  | 

### Return type

[**Prediction**](Prediction.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **matchesControllerUpdateMatch**
> matchesControllerUpdateMatch(id, terminateMatchDto)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getMatchesApi();
final String id = id_example; // String | 
final TerminateMatchDto terminateMatchDto = ; // TerminateMatchDto | 

try {
    api.matchesControllerUpdateMatch(id, terminateMatchDto);
} on DioException catch (e) {
    print('Exception when calling MatchesApi->matchesControllerUpdateMatch: $e\n');
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

# **matchesControllerUpdatePrediction**
> Prediction matchesControllerUpdatePrediction(id, updatePredictionDto)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getMatchesApi();
final String id = id_example; // String | 
final UpdatePredictionDto updatePredictionDto = ; // UpdatePredictionDto | 

try {
    final response = api.matchesControllerUpdatePrediction(id, updatePredictionDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MatchesApi->matchesControllerUpdatePrediction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updatePredictionDto** | [**UpdatePredictionDto**](UpdatePredictionDto.md)|  | 

### Return type

[**Prediction**](Prediction.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

