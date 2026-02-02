# openapi.api.NotificationsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**notificationsControllerDeleteNotification**](NotificationsApi.md#notificationscontrollerdeletenotification) | **DELETE** /notifications/{id} | 
[**notificationsControllerGetUserNotifications**](NotificationsApi.md#notificationscontrollergetusernotifications) | **GET** /notifications/user | 
[**notificationsControllerMarkNotificationAsRead**](NotificationsApi.md#notificationscontrollermarknotificationasread) | **PATCH** /notifications/{notificationId}/read | 
[**notificationsControllerSse**](NotificationsApi.md#notificationscontrollersse) | **GET** /notifications/sse | 


# **notificationsControllerDeleteNotification**
> notificationsControllerDeleteNotification(id)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNotificationsApi();
final String id = id_example; // String | 

try {
    api.notificationsControllerDeleteNotification(id);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->notificationsControllerDeleteNotification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **notificationsControllerGetUserNotifications**
> BuiltList<Notification> notificationsControllerGetUserNotifications()



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNotificationsApi();

try {
    final response = api.notificationsControllerGetUserNotifications();
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->notificationsControllerGetUserNotifications: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;Notification&gt;**](Notification.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **notificationsControllerMarkNotificationAsRead**
> notificationsControllerMarkNotificationAsRead(notificationId)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNotificationsApi();
final String notificationId = notificationId_example; // String | 

try {
    api.notificationsControllerMarkNotificationAsRead(notificationId);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->notificationsControllerMarkNotificationAsRead: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **notificationId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **notificationsControllerSse**
> notificationsControllerSse()



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getNotificationsApi();

try {
    api.notificationsControllerSse();
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->notificationsControllerSse: $e\n');
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

