import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';

import '../../Utility/request_utility.dart';

class UserService {
  /// Delete the user from the server
  ///
  /// [url] is the base url of the server
  ///
  /// [token] is the authentication token of the user
  ///
  /// [password] is the password of the user
  ///
  /// Returns a boolean value indicating whether the user was deleted successfully
  ///
  /// Throws an exception if the user was not deleted successfully
  static Future<bool> deleteUser(
      String url, String token, String password) async {
    ApiClient apiClient = RequestUtility.getApiWithAuth(url, token);
    UsersApi usersApi = UsersApi(apiClient);

    try {
      final Map<String, String> credentials =
          await AuthService.getAuthenticationCredentials();
      if (credentials["password"] != password) {
        throw Exception("No credentials found");
      }
    } catch (e) {
      return false;
    }
    await usersApi
        .userDeleteDeleteWithHttpInfo()
        .then((value) async => {
              if (value.statusCode == 200)
                {
                  await AuthService.deleteAuthenticationCredentials(),
                }
            })
        .catchError((onError) => throw Exception(onError.toString()));
    return true;
  }
}
