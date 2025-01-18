# anonkey_frontend.api.UsersApi

## Load the API package
```dart
import 'package:anonkey_frontend/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userCreatePost**](UsersApi.md#usercreatepost) | **POST** /user/create | Creates a new user.
[**userDeleteDelete**](UsersApi.md#userdeletedelete) | **DELETE** /user/delete | Deletes an existing user.
[**userGetGet**](UsersApi.md#usergetget) | **GET** /user/get | Gets information for an existing user.
[**userUpdatePut**](UsersApi.md#userupdateput) | **PUT** /user/update | Updates an existing user.


# **userCreatePost**
> UsersCreateResponseBody userCreatePost(usersCreateRequestBody)

Creates a new user.

### Example
```dart
import 'package:anonkey_frontend/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api_instance = UsersApi();
final usersCreateRequestBody = UsersCreateRequestBody(); // UsersCreateRequestBody | 

try {
    final result = api_instance.userCreatePost(usersCreateRequestBody);
    print(result);
} catch (e) {
    print('Exception when calling UsersApi->userCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **usersCreateRequestBody** | [**UsersCreateRequestBody**](UsersCreateRequestBody.md)|  | 

### Return type

[**UsersCreateResponseBody**](UsersCreateResponseBody.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userDeleteDelete**
> userDeleteDelete()

Deletes an existing user.

### Example
```dart
import 'package:anonkey_frontend/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api_instance = UsersApi();

try {
    api_instance.userDeleteDelete();
} catch (e) {
    print('Exception when calling UsersApi->userDeleteDelete: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userGetGet**
> UsersGetResponseBody userGetGet()

Gets information for an existing user.

### Example
```dart
import 'package:anonkey_frontend/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api_instance = UsersApi();

try {
    final result = api_instance.userGetGet();
    print(result);
} catch (e) {
    print('Exception when calling UsersApi->userGetGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UsersGetResponseBody**](UsersGetResponseBody.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userUpdatePut**
> userUpdatePut(usersUpdateRequestBody)

Updates an existing user.

### Example
```dart
import 'package:anonkey_frontend/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api_instance = UsersApi();
final usersUpdateRequestBody = UsersUpdateRequestBody(); // UsersUpdateRequestBody | 

try {
    api_instance.userUpdatePut(usersUpdateRequestBody);
} catch (e) {
    print('Exception when calling UsersApi->userUpdatePut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **usersUpdateRequestBody** | [**UsersUpdateRequestBody**](UsersUpdateRequestBody.md)|  | 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

