# anonkey_frontend.api.AuthenticationApi

## Load the API package
```dart
import 'package:anonkey_frontend/api.dart';
```

All URIs are relative to *https://api.beta.anonkey.lightjack.de*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authenticationChangePasswordPut**](AuthenticationApi.md#authenticationchangepasswordput) | **PUT** /authentication/changePassword | Changes a users password.
[**authenticationLoginPost**](AuthenticationApi.md#authenticationloginpost) | **POST** /authentication/login | Authenticates the user and returns an access token.
[**authenticationLogoutDelete**](AuthenticationApi.md#authenticationlogoutdelete) | **DELETE** /authentication/logout | Invalidates an access token for user logout.


# **authenticationChangePasswordPut**
> authenticationChangePasswordPut(authenticationChangePasswordRequestBody)

Changes a users password.

### Example
```dart
import 'package:anonkey_frontend/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api_instance = AuthenticationApi();
final authenticationChangePasswordRequestBody = AuthenticationChangePasswordRequestBody(); // AuthenticationChangePasswordRequestBody | 

try {
    api_instance.authenticationChangePasswordPut(authenticationChangePasswordRequestBody);
} catch (e) {
    print('Exception when calling AuthenticationApi->authenticationChangePasswordPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authenticationChangePasswordRequestBody** | [**AuthenticationChangePasswordRequestBody**](AuthenticationChangePasswordRequestBody.md)|  | 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authenticationLoginPost**
> AuthenticationLoginResponseBody authenticationLoginPost(authenticationLoginRequestBody)

Authenticates the user and returns an access token.

### Example
```dart
import 'package:anonkey_frontend/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api_instance = AuthenticationApi();
final authenticationLoginRequestBody = AuthenticationLoginRequestBody(); // AuthenticationLoginRequestBody | 

try {
    final result = api_instance.authenticationLoginPost(authenticationLoginRequestBody);
    print(result);
} catch (e) {
    print('Exception when calling AuthenticationApi->authenticationLoginPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authenticationLoginRequestBody** | [**AuthenticationLoginRequestBody**](AuthenticationLoginRequestBody.md)|  | 

### Return type

[**AuthenticationLoginResponseBody**](AuthenticationLoginResponseBody.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authenticationLogoutDelete**
> authenticationLogoutDelete()

Invalidates an access token for user logout.

### Example
```dart
import 'package:anonkey_frontend/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api_instance = AuthenticationApi();

try {
    api_instance.authenticationLogoutDelete();
} catch (e) {
    print('Exception when calling AuthenticationApi->authenticationLogoutDelete: $e\n');
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

