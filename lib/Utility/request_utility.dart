import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:flutter/foundation.dart';

class RequestUtility {
  static ApiClient getApiWithAuth(String authentication, String basePath) {
    if (kDebugMode && basePath.isEmpty) {
      basePath = "https://api.beta.anonkey.lightjack.de";
    }
    ApiClient client = ApiClient(basePath: basePath);
    client.addDefaultHeader("Authorization", "Bearer $authentication");
    return client;
  }

  static ApiClient getApiWithoutAuth(String basePath) {
    if (kDebugMode && basePath.isEmpty) {
      basePath = "https://api.beta.anonkey.lightjack.de";
    }
    return ApiClient(basePath: basePath);
  }
}
