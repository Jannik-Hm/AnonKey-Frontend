import 'package:anonkey_frontend/Utility/api_base_data.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:flutter/foundation.dart';

class RequestUtility {
  static ApiClient getApiWithAuth(String authentication, String basePath) {
    if (kDebugMode && basePath.isEmpty) {
      ApiBaseData.setURL("https://api.anonkey.lightjack.de");
      basePath = "https://api.anonkey.lightjack.de";
    }
    ApiClient client = ApiClient(basePath: basePath);
    client.addDefaultHeader("Authorization", "Bearer $authentication");
    return client;
  }

  static ApiClient getApiWithoutAuth(String basePath) {
    if (kDebugMode && basePath.isEmpty) {
      ApiBaseData.setURL("https://api.anonkey.lightjack.de");
      basePath = "https://api.anonkey.lightjack.de";
    }
    return ApiClient(basePath: basePath);
  }
}
