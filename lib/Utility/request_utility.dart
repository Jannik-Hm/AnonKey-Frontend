import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RequestUtility {
  static getApiWithAuth(String authentication, String basePath) {
    return ApiClient(basePath: basePath)
        .addDefaultHeader("Authorization", "Bearer $authentication");
  }

  static getApiWithoutAuth(String basePath) {
    return ApiClient(basePath: basePath);
  }
}
