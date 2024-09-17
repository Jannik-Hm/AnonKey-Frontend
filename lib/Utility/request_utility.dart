import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RequestUtility {
  static getApiWithAuth(String authentication) {
    return ApiClient(basePath: dotenv.env['CLIENT_URL'] ?? "")
        .addDefaultHeader("Authorization", authentication);
  }

  static getApiWithoutAuth() {
    return ApiClient(basePath: dotenv.env['CLIENT_URL'] ?? "");
  }
}
