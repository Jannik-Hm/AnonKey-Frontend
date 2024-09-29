import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/exception/auth_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The authentication service.
///
/// This service provides methods to login and register a user.
///
class AuthService {
  /// Logs in a user.
  ///
  /// \returns `true` if the login was successful, `false` otherwise.
  ///
  /// [username]: The username.
  ///
  /// [password]: The password.
  ///
  static Future<bool> login(
      String username, String password, String url) async {
    ApiClient apiClient = RequestUtility.getApiWithoutAuth(url);
    AuthenticationApi authApi = AuthenticationApi(apiClient);
    try {
      AuthenticationLoginRequestBody loginBody = AuthenticationLoginRequestBody(
        userName: username,
        kdfPasswordResult: password,
      );
      await authApi.authenticationLoginPost(loginBody).then((value) async => {
            if (value?.token != null)
              {
                storeAuthenticationCredentials(
                    value?.token, username, password),
              }
          });
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Registers a new user.
  ///
  /// \returns `true` if the registration was successful, `false` otherwise.
  ///
  /// [username]: The username.
  ///
  /// [password]: The password.
  ///
  /// [displayName]: The display name.
  ///
  static Future<bool> register(
      String username, String password, String? displayName, String url) async {
    displayName = username;

    ApiClient apiClient = RequestUtility.getApiWithoutAuth(url);
    UsersApi authApi = UsersApi(apiClient);
    try {
      UsersCreateRequestBody registerBody = UsersCreateRequestBody(
        userName: username,
        userDisplayName: username,
        kdfPasswordResult: password,
      );
      await authApi.userCreatePost(registerBody).then((value) async => {
            if (value?.token != null)
              {
                storeAuthenticationCredentials(
                    value?.token, username, password),
              }
          });
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retrieves the authentication data from the secure storage.
  ///
  /// \returns A `Map<String, String>` containing the token, username, and password.
  ///
  /// [token]: The authentication token.
  ///
  /// [username]: The username.
  ///
  /// [password]: The password.
  ///
  /// \throws [NoCredentialException] if no data is found.
  static Future<Map<String, String>> getAuthenticationCredentials() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    String? username = await storage.read(key: "username");
    String? password = await storage.read(key: "password");
    if (token == null || username == null || password == null) {
      throw NoCredentialException();
    }
    return {"token": token, "username": username, "password": password};
  }

  /// Stores the authentication data in the secure storage.
  ///
  /// [token]: The authentication token.
  ///
  /// [username]: The username.
  ///
  /// [password]: The password.
  static void storeAuthenticationCredentials(
      String? token, String username, String password) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: "token", value: token);
    await storage.write(key: "password", value: password);
    await storage.write(key: "username", value: username);
  }
}
