# anonkey_frontend.api.UUIDApi

## Load the API package

```dart
import 'package:anonkey_frontend/api.dart';
```

All URIs are relative to *http://localhost*

 Method                                  | HTTP request      | Description                               
-----------------------------------------|-------------------|-------------------------------------------
 [**uuidNewGet**](UUIDApi.md#uuidnewget) | **GET** /uuid/new | Returns a new UUID for several endpoints. 

# **uuidNewGet**

> String uuidNewGet()

Returns a new UUID for several endpoints.

### Example

```dart
import 'package:anonkey_frontend/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api_instance = UUIDApi();

try {
    final result = api_instance.uuidNewGet();
    print(result);
} catch (e) {
    print('Exception when calling UUIDApi->uuidNewGet: $e\n');
}
```

### Parameters

This endpoint does not need any parameter.

### Return type

**String**

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

