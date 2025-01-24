import 'package:anonkey_frontend/Utility/api_base_data.dart';
import 'package:anonkey_frontend/Utility/auth_utils.dart';
import 'package:anonkey_frontend/Utility/cryptography.dart';
import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/exception/auth_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum TokenType {
  refreshToken,
  accessToken,
}

extension TokenTypeExtension on TokenType {
  Duration validationRange() {
    if (this.index == 0) {
      return Duration(days: 30);
    } else {
      return Duration(minutes: 30);
    }
  }
}

// It should be more concise to pack each token in a class, so that all information such as expiration time can be easily accessible
class Token {
  String token;
  TokenType tokenType;
  int expiration;

  Token(
      {required this.token, required this.tokenType, required this.expiration});
}

class AuthenticationCredentialsSingleton {
  static final AuthenticationCredentialsSingleton _singleton =
      AuthenticationCredentialsSingleton._internal();

  String? encryptionKDF; // always in RAM if not taken from the secure storage
  Token? refreshToken;
  Token? accessToken;

  String? username;
  bool softLogout = true;
  bool skipSplashScreen = false;

  @override
  String toString() {
    // TODO: implement toString
    return "Username: $username\nEncryptionKDF: $encryptionKDF\nRefreshToken: ${refreshToken?.token}\nRefreshExpiration: ${refreshToken?.expiration}\nAccessToken: ${accessToken?.token}\nAccessExpiration: ${accessToken?.expiration}\nSoftLogout: $softLogout\nSkipSplashScreen: $skipSplashScreen";
  }

  factory AuthenticationCredentialsSingleton() {
    return _singleton;
  }

  deleteAuthenticationCredentialsSingleton() {
    refreshToken = null;
    accessToken = null;
    encryptionKDF = null;
    username = null;
    softLogout = true;
    skipSplashScreen = false;
  }

  areAuthenticationCredentialsAvailable() {
    if (refreshToken != null && accessToken != null && username != null) {
      return true;
    } else {
      throw NoTokensFoundException();
    }
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
    String encryptionKDF = await Cryptography.getKDFBase64(
      masterPassword: password,
      salt: "${username}_encryption",
    );
    try {
      AuthenticationLoginRequestBody loginBody = AuthenticationLoginRequestBody(
        userName: username,
        kdfPasswordResult: masterKDF,
      );
      await authApi.authenticationLoginPost(loginBody).then((value) async => {
            if (value?.accessToken != null && value?.refreshToken != null)
              {
                await storeAuthenticationCredentials(
                  username: username,
                  encryptionKDF: encryptionKDF,
                  refreshToken: value!.refreshToken!.token!,
                  refreshExpiration: value.refreshToken!.expiryTimestamp!,
                  accessToken: value.accessToken!.token!,
                  accessExpiration: value.accessToken!.expiryTimestamp!,
                ),
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
            if (value?.accessToken != null && value?.refreshToken != null)
              {
                await storeAuthenticationCredentials(
                  username: username,
                  encryptionKDF: encryptionKDF,
                  refreshToken: value!.refreshToken!.token!,
                  refreshExpiration: value.refreshToken!.expiryTimestamp!,
                  accessToken: value.accessToken!.token!,
                  accessExpiration: value.accessToken!.expiryTimestamp!,
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
    if (await AuthUtils.checkBiometricAvailability() ||
        singleton.encryptionKDF == null) {
      singleton.encryptionKDF = await storage.read(key: "encryptionKDF");
    } // otherwise the token is already in the singleton
    singleton.username ??= await storage.read(key: "username");
    singleton.skipSplashScreen ??=
        await storage.read(key: "skipSplashScreen") == "true" ? true : false;
    int refreshExpiration = await storage.containsKey(key: "refreshExpiration")
        ? int.parse((await storage.read(key: "refreshExpiration"))!)
        : 0;
    if ((await storage.read(key: "refreshToken") != null) &&
        (singleton.refreshToken == null)) {
      singleton.refreshToken ??= Token(
          token: (await storage.read(key: "refreshToken"))!,
          tokenType: TokenType.refreshToken,
          expiration: refreshExpiration);
    }
    if (singleton.refreshToken == null) {
      if (!validateToken(
          timestamp: singleton.refreshToken?.expiration,
          tokenType: TokenType.refreshToken)) {
        // Fetch refresh token here
      }
    } else {
      if (singleton.accessToken == null ||
          !validateToken(
              timestamp: singleton.accessToken!.expiration,
              tokenType: TokenType.accessToken)) {
        //Fetch access token here
        String? url = await ApiBaseData.getURL();
        print("test");
        if (url != null) {
          ApiClient api =
              RequestUtility.getApiWithAuth(singleton.refreshToken!.token, url);
          AuthenticationApi authenticationApi = AuthenticationApi(api);
          authenticationApi
              .authenticationRefreshAccessTokenPost()
              .then((value) => {
                    singleton.accessToken = Token(
                        token: value!.accessToken!.token!,
                        tokenType: TokenType.accessToken,
                        expiration: value.accessToken!.expiryTimestamp!)
                  });
        }
      }
    }
    print(singleton.toString());
    try {
      singleton.areAuthenticationCredentialsAvailable();
    } catch (_) {
      rethrow;
    }
    return singleton;
  }

  /// Validates the authentication token. If the token is invalid, the user is logged in again but only if the token is still in the valid range.
  ///
  /// \returns `true` if the token is invalid, `false` otherwise.
  ///
  /// [timestamp]: The timestamp.
  ///
  /// [tokenType]: The tokenType.
  static bool validateToken(
      {required int? timestamp, required TokenType tokenType}) {
    if (timestamp == null) return false;
    DateTime validUntil = DateTime.fromMicrosecondsSinceEpoch(timestamp);
    Duration timeStampDifference = DateTime.now().difference(validUntil);
    if (timeStampDifference * 0.8 < tokenType.validationRange()) {
      return false;
    }
    return true;
  }

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
    required String username,
    required String encryptionKDF,
    required String refreshToken,
    required int refreshExpiration,
    required String accessToken,
    required int accessExpiration,
  }) async {
    // Store in RAM
    var singleton = AuthenticationCredentialsSingleton();
    singleton.encryptionKDF = encryptionKDF;
    singleton.username = username;
    singleton.softLogout = true;
    singleton.skipSplashScreen = false;
    singleton.refreshToken = Token(
        token: refreshToken,
        tokenType: TokenType.refreshToken,
        expiration: refreshExpiration);
    singleton.accessToken = Token(
        token: accessToken,
        tokenType: TokenType.accessToken,
        expiration: accessExpiration);
    // Store in secure storage
    const storage = FlutterSecureStorage();
    if (await AuthUtils.checkBiometricAvailability()) {
      await storage.write(key: "encryptionKDF", value: encryptionKDF);
    }
    await storage.write(key: "username", value: username);
    await storage.write(key: "refreshToken", value: refreshToken);
    await storage.write(
        key: "refreshExpiration", value: refreshExpiration.toString());
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
    await storage.delete(key: "refreshExpiration");
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
