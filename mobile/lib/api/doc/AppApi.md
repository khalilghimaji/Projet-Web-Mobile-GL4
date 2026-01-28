# openapi.api.AppApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**appControllerGetHello**](AppApi.md#appcontrollergethello) | **GET** / | 
[**appControllerUploadFile**](AppApi.md#appcontrolleruploadfile) | **POST** /upload | 


# **appControllerGetHello**
> String appControllerGetHello()



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAppApi();

try {
    final response = api.appControllerGetHello();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AppApi->appControllerGetHello: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **appControllerUploadFile**
> appControllerUploadFile(file)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAppApi();
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile | 

try {
    api.appControllerUploadFile(file);
} on DioException catch (e) {
    print('Exception when calling AppApi->appControllerUploadFile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **file** | **MultipartFile**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

