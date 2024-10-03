# anonkey_frontend.api.ServiceApi

## Load the API package
```dart
import 'package:anonkey_frontend/api.dart';
```

All URIs are relative to *https://api.beta.anonkey.lightjack.de*

Method | HTTP request | Description
------------- | ------------- | -------------
[**servicePingGet**](ServiceApi.md#servicepingget) | **GET** /service/ping | Checks the connection to the server.


# **servicePingGet**
> String servicePingGet()

Checks the connection to the server.

### Example
```dart
import 'package:anonkey_frontend/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api_instance = ServiceApi();

try {
    final result = api_instance.servicePingGet();
    print(result);
} catch (e) {
    print('Exception when calling ServiceApi->servicePingGet: $e\n');
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
 - **Accept**: text/plain

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

