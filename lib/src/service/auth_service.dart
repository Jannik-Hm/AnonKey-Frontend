import 'package:anonkey_frontend/Utility/cryptography.dart';
import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/exception/auth_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    String username,
    String password,
    String url,
  ) async {
    ApiClient apiClient = RequestUtility.getApiWithoutAuth(url);
    AuthenticationApi authApi = AuthenticationApi(apiClient);
    String masterKDF = await Cryptography.getKDFBase64(
      masterPassword: password,
      salt: "${username}_authentication",
    );
    try {
      AuthenticationLoginRequestBody loginBody = AuthenticationLoginRequestBody(
        userName: username,
        kdfPasswordResult: masterKDF,
      );
      await authApi
          .authenticationLoginPost(loginBody)
          .then(
            (value) async => {
              if (value?.token != null)
                {
                  await storeAuthenticationCredentials(
                    value?.token,
                    username,
                    password,
                    value!.expiresInSeconds!,
                  ),
                },
            },
          );
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
    String username,
    String password,
    String? displayName,
    String url,
  ) async {
    displayName = username;

    ApiClient apiClient = RequestUtility.getApiWithoutAuth(url);
    UsersApi authApi = UsersApi(apiClient);
    String masterKDF = await Cryptography.getKDFBase64(
      masterPassword: password,
      salt: "${username}_authentication",
    );
    try {
      UsersCreateRequestBody registerBody = UsersCreateRequestBody(
        userName: username,
        userDisplayName: username,
        kdfPasswordResult: masterKDF,
      );
      await authApi
          .userCreatePost(registerBody)
          .then(
            (value) async => {
              if (value?.token != null)
                {
                  await storeAuthenticationCredentials(
                    value?.token,
                    username,
                    password,
                    value!.expiresInSeconds!,
                  ),
                },
            },
          );
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
    String? encryptionKDF =
        (password == null || username == null)
            ? ""
            : await Cryptography.getKDFBase64(
              masterPassword: password,
              salt: "${username}_encryption",
              kdfMode: KDFMode.master,
            );
    String? timestampStorage = await storage.read(key: "timestamp");
    int expire = int.parse(await storage.read(key: "expire") ?? "0");
    if (token == null ||
        username == null ||
        password == null ||
        timestampStorage == null) {
      throw NoCredentialException();
    }
    if (!(await validateToken(username, password, timestampStorage, expire))) {
      return getAuthenticationCredentials();
    }
    return {
      "token": token,
      "username": username,
      "password": password,
      "encryptionKDF": encryptionKDF,
    };
  }

  /// Validates the authentication token. If the token is invalid, the user is logged in again but only if the token is still in the valid range.
  ///
  /// \returns `true` if the token is invalid, `false` otherwise.
  ///
  /// [username]: The username.
  ///
  /// [password]: The password.
  ///
  /// [timestampStorage]: The timestamp when the token was stored.
  ///
  /// [expire]: The expiration time of the token.
  static Future<bool> validateToken(
    String username,
    String password,
    String timestampStorage,
    int expire,
  ) async {
    DateTime timestamp = DateTime.parse(timestampStorage);
    DateTime now = DateTime.now();
    Duration difference = now.difference(timestamp);

    int minRange = (expire * 0.8).toInt();
    //int maxRange = (expire).toInt();

    if (difference.inSeconds >= minRange) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await AuthService.login(username, password, prefs.getString("url")!);
      return false;
    }
    return true;
  }

  /// Stores the authentication data in the secure storage.
  ///
  /// [token]: The authentication token.
  ///
  /// [username]: The username.
  ///
  /// [password]: The password.
  static Future<void> storeAuthenticationCredentials(
    String? token,
    String username,
    String password,
    int expire,
  ) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: "token", value: token);
    await storage.write(
      key: "timestamp",
      value: DateTime.now().toIso8601String(),
    );
    await storage.write(key: "password", value: password);
    await storage.write(key: "username", value: username);
    await storage.write(key: "expire", value: expire.toString());
    await storage.write(key: "softLogout", value: false.toString());
    await storage.write(key: "skipSplashScreen", value: "false");
  }

  static Future<void> deleteAuthenticationCredentials() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: "token");
    await storage.delete(key: "timestamp");
    await storage.delete(key: "password");
    await storage.delete(key: "expire");
    await storage.delete(key: "username");
  }

  /// softLogout is used to indicate that the user has logged out without deleting the authentication data.
  /// This is useful to determine if the user should be redirected to the login page.
  static Future<void> softLogout() async {
    const storage = FlutterSecureStorage();
    await storage.write(key: "softLogout", value: true.toString());
  }

  /// Checks if a soft logout is active.
  /// \returns `true` if a soft logout is active, `false` otherwise.
  ///
  /// A soft logout is active if the user has logged out without deleting the authentication data.
  /// This is useful to determine if the user should be redirected to the login page.
  static Future<bool> isSoftLogout() async {
    const storage = FlutterSecureStorage();
    if (!(await storage.containsKey(key: "softLogout"))) {
      return false;
    }
    String? softLogout = await storage.read(key: "softLogout");
    return softLogout == "true";
  }

  static Future<void> setSkipSplashScreen(bool isSkipped) async {
    const storage = FlutterSecureStorage();
    storage.write(key: 'skipSplashScreen', value: isSkipped.toString());
  }
}
