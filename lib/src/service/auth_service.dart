import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart';


class AuthService {
  static Future<bool> login(String username, String password) async {
    ApiClient apiClient = RequestUtility.getApiWithoutAuth(
        "https://api.beta.anonkey.lightjack.de/api/v1");
    AuthenticationApi authApi = AuthenticationApi(apiClient);
    try {
      AuthenticationLoginRequestBody loginBody = AuthenticationLoginRequestBody(
        userName: username,
        kdfPasswordResult: password,
      );
      var response = await authApi.authenticationLoginPost(loginBody);
      return true;
    } catch (e) {
      return false;
    }
  }
}
