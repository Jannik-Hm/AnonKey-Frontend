import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RequestUtility {
  static getApiWithAuth(String authentication) {
    return ApiClient(
            dotenv.env['CLIENT_URL'] ?? Exception('CLIENT_URL not found'))
        .addDefaultHeader("Authorization", authentication);
  }

  static getApiWithoutAuth() {
    return ApiClient(
        dotenv.env['CLIENT_URL'] ?? Exception('CLIENT_URL not found'));
  }
}
