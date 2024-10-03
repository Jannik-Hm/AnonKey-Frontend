# anonkey_frontend.api.FoldersApi

## Load the API package
```dart
import 'package:anonkey_frontend/api.dart';
```

All URIs are relative to *https://api.beta.anonkey.lightjack.de*

Method | HTTP request | Description
------------- | ------------- | -------------
[**foldersCreatePost**](FoldersApi.md#folderscreatepost) | **POST** /folders/create | Creates a new folder.
[**foldersDeleteDelete**](FoldersApi.md#foldersdeletedelete) | **DELETE** /folders/delete | Deletes an existing folder.
[**foldersGetAllGet**](FoldersApi.md#foldersgetallget) | **GET** /folders/getAll | Gets all folders for a user.
[**foldersGetGet**](FoldersApi.md#foldersgetget) | **GET** /folders/get | Gets information on an existing folder.
[**foldersUpdatePut**](FoldersApi.md#foldersupdateput) | **PUT** /folders/update | Updates an existing folder object.


# **foldersCreatePost**
> FoldersCreateResponseBody foldersCreatePost(foldersCreateRequestBody)

Creates a new folder.

### Example
```dart
import 'package:anonkey_frontend/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api_instance = FoldersApi();
final foldersCreateRequestBody = FoldersCreateRequestBody(); // FoldersCreateRequestBody | 

try {
    final result = api_instance.foldersCreatePost(foldersCreateRequestBody);
    print(result);
} catch (e) {
    print('Exception when calling FoldersApi->foldersCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **foldersCreateRequestBody** | [**FoldersCreateRequestBody**](FoldersCreateRequestBody.md)|  | 

### Return type

[**FoldersCreateResponseBody**](FoldersCreateResponseBody.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **foldersDeleteDelete**
> foldersDeleteDelete(folderUuid, recursive)

Deletes an existing folder.

### Example
```dart
import 'package:anonkey_frontend/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api_instance = FoldersApi();
final folderUuid = folderUuid_example; // String | 
final recursive = true; // bool | 

try {
    api_instance.foldersDeleteDelete(folderUuid, recursive);
} catch (e) {
    print('Exception when calling FoldersApi->foldersDeleteDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **folderUuid** | **String**|  | 
 **recursive** | **bool**|  | 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **foldersGetAllGet**
> FoldersGetAllResponseBody foldersGetAllGet()

Gets all folders for a user.

### Example
```dart
import 'package:anonkey_frontend/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api_instance = FoldersApi();

try {
    final result = api_instance.foldersGetAllGet();
    print(result);
} catch (e) {
    print('Exception when calling FoldersApi->foldersGetAllGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**FoldersGetAllResponseBody**](FoldersGetAllResponseBody.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **foldersGetGet**
> FoldersGetResponseBody foldersGetGet(folderUuid)

Gets information on an existing folder.

### Example
```dart
import 'package:anonkey_frontend/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api_instance = FoldersApi();
final folderUuid = folderUuid_example; // String | 

try {
    final result = api_instance.foldersGetGet(folderUuid);
    print(result);
} catch (e) {
    print('Exception when calling FoldersApi->foldersGetGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **folderUuid** | **String**|  | 

### Return type

[**FoldersGetResponseBody**](FoldersGetResponseBody.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **foldersUpdatePut**
> FoldersUpdateResponseBody foldersUpdatePut(foldersUpdateRequestBody)

Updates an existing folder object.

### Example
```dart
import 'package:anonkey_frontend/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api_instance = FoldersApi();
final foldersUpdateRequestBody = FoldersUpdateRequestBody(); // FoldersUpdateRequestBody | 

try {
    final result = api_instance.foldersUpdatePut(foldersUpdateRequestBody);
    print(result);
} catch (e) {
    print('Exception when calling FoldersApi->foldersUpdatePut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **foldersUpdateRequestBody** | [**FoldersUpdateRequestBody**](FoldersUpdateRequestBody.md)|  | 

### Return type

[**FoldersUpdateResponseBody**](FoldersUpdateResponseBody.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

