import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:flutter/foundation.dart';

class RequestUtility {
  static getApiWithAuth(String authentication, String basePath) {
    if (kDebugMode) {
      basePath = "https://api.beta.anonkey.lightjack.de";
    }
    return ApiClient(basePath: basePath)
        .addDefaultHeader("Authorization", "Bearer $authentication");
  }

  static getApiWithoutAuth(String basePath) {
    if (kDebugMode) {
      basePath = "https://api.beta.anonkey.lightjack.de";
    }
    return ApiClient(basePath: basePath);
  }
}
