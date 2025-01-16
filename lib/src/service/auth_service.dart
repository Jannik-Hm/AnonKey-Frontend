import 'package:anonkey_frontend/Utility/auth_utils.dart';
import 'package:anonkey_frontend/Utility/cryptography.dart';
import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/exception/auth_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationCredentialsSingleton {
  static final AuthenticationCredentialsSingleton _singleton =
      AuthenticationCredentialsSingleton._internal();

  String? encryptionKDF; // always in RAM if nor taken from the secure storage
  String? refreshToken;
  String? accessToken;
  int? refreshExpiration;
  int? accessExpiration;

  String? username;
  bool? softLogout;
  bool? skipSplashScreen;

  factory AuthenticationCredentialsSingleton() {
    return _singleton;
  }

  deleteAuthenticationCredentialsSingleton() {
    refreshToken = null;
    accessToken = null;
    encryptionKDF = null;
    refreshExpiration = null;
    accessExpiration = null;
    username = null;
    softLogout = true;
    skipSplashScreen = null;
  }

  areTockensAvailable() {
    return (refreshToken != null &&
        accessToken != null &&
        refreshExpiration != null &&
        accessExpiration != null);
  }

  AuthenticationCredentialsSingleton._internal();
}

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
    String masterKDF = await Cryptography.getKDFBase64(
      masterPassword: password,
      salt: "${username}_authentication",
    );
    try {
      AuthenticationLoginRequestBody loginBody = AuthenticationLoginRequestBody(
        userName: username,
        kdfPasswordResult: masterKDF,
      );
      await authApi.authenticationLoginPost(loginBody).then((value) async => {
            if (value?.token != null)
              {
                await storeAuthenticationCredentials(
                    // TODO: Ask Backend for the updated OpenAI specification in order to be able to parse the return object -> refresh and access tockens
                    refreshToken: value?.token,
                    username: username,
                    value!.expiresInSeconds!),
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
    String masterKDF = await Cryptography.getKDFBase64(
      masterPassword: password,
      salt: "${username}_authentication",
    );
    String encryptionKDF = await Cryptography.getKDFBase64(
        masterPassword: password, salt: "${username}_encryption");
    try {
      UsersCreateRequestBody registerBody = UsersCreateRequestBody(
        userName: username,
        userDisplayName: username,
        kdfPasswordResult: masterKDF,
      );
      await authApi.userCreatePost(registerBody).then((value) async => {
            if (value?.token != null)
              {
                // TODO: Ask Backend for the updated OpenAI specification in order to be able to parse the return object -> refresh and access tockens
                await storeAuthenticationCredentials(
                  username,
                  password,
                  encryptionKDF,
                  value?.token,
                  value!.expiresInSeconds!,
                ),
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
  static Future<AuthenticationCredentialsSingleton>
      getAuthenticationCredentials() async {
    const storage = FlutterSecureStorage();
    var singleton = AuthenticationCredentialsSingleton();
    if (await AuthUtils.checkBiometricAvailability() &&
        singleton.encryptionKDF == null) {
      singleton.encryptionKDF = await storage.read(key: "encryptionKDF");
    } // otherwise the roken is already in the singleton
    singleton.username ??= await storage.read(key: "username");
    singleton.skipSplashScreen ??=
        await storage.read(key: "skipSplashScreen") == "true" ? true : false;
    if (keys.refreshToken == null ||
        keys.accessToken == null ||
        keys.refreshExpiration == null ||
        keys.accessExpiration == null ||
        username == null) {
      throw NoCredentialException();
    }
    if (!(await validateToken(
            username, keys.timestamp, keys.refreshExpiration)) ||
        !(singleton.areTockensAvailable())) {
      // Fetch tokens here
      return getAuthenticationCredentials();
    }
    return singleton;
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
    DateTime? timestamp,
    int? expire,
  ) async {
    timestamp = (timestamp == null) ? DateTime.now() : timestamp;
    expire = (expire == null) ? 0 : expire;
    DateTime now = DateTime.now();
    Duration difference = now.difference(timestamp);

    int minRange = (expire * 0.8).toInt();

    if (difference.inSeconds >= minRange) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // TODO: Here the user shall be prompted to reenter the password, as we do not store it.
      // Swap login with a fetch of a new accessTocken
      await AuthService.login(username, password, prefs.getString("url")!);
      return false;
    }
    return true;
  }

  static Future<void> fetchNewTockens() async {}

  /// Stores the authentication data in the secure storage.
  ///
  /// [username]: The username.
  ///
  /// [encryptionKDF]: The encryption KDF.
  ///
  /// [refreshToken]: The refresh token from the server;
  ///
  /// [refreshExpiration]: The time in seconds till the expiration of the refresh token.
  ///
  /// [accessToken]: The access token from the server.
  ///
  /// [accessExpiration]: The ime in seconds till the expiration of the access token.
  static Future<void> storeAuthenticationCredentials({
    required String? username,
    required String? encryptionKDF,
    required String? refreshToken,
    required int refreshExpiration,
    required String? accessToken,
    required int accessExpiration,
  }) async {
    // Store in RAM
    var singleton = AuthenticationCredentialsSingleton();
    singleton.refreshToken = refreshToken;
    singleton.accessToken = accessToken;
    singleton.encryptionKDF = encryptionKDF;
    singleton.username = username;
    singleton.refreshExpiration = refreshExpiration;
    singleton.accessExpiration = accessExpiration;
    singleton.softLogout = true;
    singleton.skipSplashScreen = false;
    // Store in secure storage
    const storage = FlutterSecureStorage();
    if (await AuthUtils.checkBiometricAvailability()) {
      await storage.write(key: "encryptionKDF", value: encryptionKDF);
    }
    await storage.write(key: "username", value: username);
    await storage.write(key: "refreshToken", value: refreshToken);
  }

  static Future<void> deleteAuthenticationCredentials() async {
    // Clean up RAM
    AuthenticationCredentialsSingleton()
        .deleteAuthenticationCredentialsSingleton();
    // CLean up secure storage
    const storage = FlutterSecureStorage();
    if (await AuthUtils.checkBiometricAvailability()) {
      await storage.delete(key: "encryptionKDF");
    }
    await storage.delete(key: "username");
    await storage.delete(key: "refreshToken");
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
