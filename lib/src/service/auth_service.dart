import 'dart:async';
import 'dart:convert';

import 'package:anonkey_frontend/Utility/api_base_data.dart';
import 'package:anonkey_frontend/Utility/auth_utils.dart';
import 'package:anonkey_frontend/Utility/cryptography.dart';
import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/exception/auth_exception.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum TokenType { refreshToken, accessToken }

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

  Token({
    required this.token,
    required this.tokenType,
    required this.expiration,
  });
}

class AuthenticationCredentialsSingleton {
  /// Use the getAuthenticationCredentials from the AuthService to get the singleton.
  static final AuthenticationCredentialsSingleton _singleton =
      AuthenticationCredentialsSingleton._internal();

  String? encryptionKDF; // always in RAM if not taken from the secure storage
  String? validationHash;
  Token? refreshToken;
  Token? accessToken;

  String? username;
  bool softLogout = false;
  bool skipSplashScreen = false;

  @override
  String toString() {
    // TODO: implement toString
    return "username: $username,\nencryptionKDF: $encryptionKDF,\nrefreshToken: ${refreshToken?.token},\naccessToken: ${accessToken?.token},\nsoftLogout: $softLogout,\nskipSplashScreen: $skipSplashScreen";
  }

  factory AuthenticationCredentialsSingleton() {
    return _singleton;
  }

  deleteAuthenticationCredentialsSingleton() {
    refreshToken = null;
    accessToken = null;
    encryptionKDF = null;
    validationHash = null;
    username = null;
    softLogout = true;
    skipSplashScreen = false;
  }

  areAuthenticationCredentialsAvailable() {
    if (refreshToken != null &&
        accessToken != null &&
        username != null &&
        validationHash != null) {
      return true;
    } else {
      return false;
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
    String encryptionKDF = await Cryptography.getKDFBase64(
      masterPassword: password,
      salt: "${username}_encryption",
    );
    try {
      AuthenticationLoginRequestBody loginBody = AuthenticationLoginRequestBody(
        userName: username,
        kdfPasswordResult: masterKDF,
      );
      await authApi.authenticationLoginPost(loginBody).then(
            (value) async => {
              if (value?.accessToken != null && value?.refreshToken != null)
                {
                  await storeAuthenticationCredentials(
                    username: username,
                    encryptionKDF: encryptionKDF,
                    refreshToken: value!.refreshToken!.token!,
                    refreshExpiration: value.refreshToken!.expiryTimestamp!,
                    accessToken: value.accessToken!.token!,
                    accessExpiration: value.accessToken!.expiryTimestamp!,
                    softLogout: true,
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
    String encryptionKDF = await Cryptography.getKDFBase64(
      masterPassword: password,
      salt: "${username}_encryption",
    );
    try {
      UsersCreateRequestBody registerBody = UsersCreateRequestBody(
        userName: username,
        userDisplayName: username,
        kdfPasswordResult: masterKDF,
      );
      await authApi.userCreatePost(registerBody).then(
            (value) async => {
              if (value?.accessToken != null && value?.refreshToken != null)
                {
                  await storeAuthenticationCredentials(
                    username: username,
                    encryptionKDF: encryptionKDF,
                    refreshToken: value!.refreshToken!.token!,
                    refreshExpiration: value.refreshToken!.expiryTimestamp!,
                    accessToken: value.accessToken!.token!,
                    accessExpiration: value.accessToken!.expiryTimestamp!,
                    softLogout: true,
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
  static Future<AuthenticationCredentialsSingleton>
      getAuthenticationCredentials() async {
    const storage = FlutterSecureStorage();
    var singleton = AuthenticationCredentialsSingleton();

    //if(!(await AuthService.isOffline()) && singleton.accessToken.)

    if (!singleton.areAuthenticationCredentialsAvailable()) {
      if (await storage.containsKey(key: "encryptionKDF") &&
          await AuthUtils.checkBiometricAvailability() &&
          singleton.encryptionKDF == null) {
        singleton.encryptionKDF = await storage.read(key: "encryptionKDF");
      }
      singleton.username = await storage.read(key: "username");
      singleton.validationHash = await storage.read(key: "validationHash");
      singleton.skipSplashScreen =
          await storage.read(key: "skipSplashScreen") == "true" ? true : false;

      // Read refresh token from storage
      if ((await storage.read(key: "refreshToken") != null) &&
          (singleton.refreshToken == null)) {
        int refreshExpiration = int.parse(
          await storage.read(key: "refreshExpiration") ?? "0",
        );
        singleton.refreshToken = Token(
          token: (await storage.read(key: "refreshToken"))!,
          tokenType: TokenType.refreshToken,
          expiration: refreshExpiration,
        );
      }

      if (!validateToken(
            timestamp: singleton.refreshToken?.expiration,
            tokenType: TokenType.refreshToken,
          ) &&
          !(await AuthService.isOffline()) &&
          (await storage.read(key: "refreshToken") != null)) {
        await _refreshRefreshToken();
      }
    }

    return singleton;
  }

  static Future<void> _refreshRefreshToken() async {
    const storage = FlutterSecureStorage();
    var singleton = AuthenticationCredentialsSingleton();
    ApiClient api = RequestUtility.getApiWithAuth(
      AuthenticationCredentialsSingleton().refreshToken!.token,
      (await ApiBaseData.getURL()) as String,
    );
    AuthenticationApi authenticationApi = AuthenticationApi(api);
    await ApiBaseData.apiCallWrapper(
      authenticationApi.authenticationRefreshRefreshTokenPost(),
      logMessage: "Fetching Refresh Token",
    ).then((value) async {
      singleton.refreshToken = Token(
        token: value!.refreshToken!.token!,
        tokenType: TokenType.refreshToken,
        expiration: value.refreshToken!.expiryTimestamp!,
      );
      await storage.write(
        key: "refreshToken",
        value: value.refreshToken!.token!,
      );
    }).onError((error, stackTrace) {
      singleton.deleteAuthenticationCredentialsSingleton();
      storage.deleteAll();
    });
  }

  static Future<bool> isOffline() async {
    ServiceApi serviceApi = ServiceApi(
      RequestUtility.getApiWithoutAuth((await ApiBaseData.getURL()) as String),
    );
    return ApiBaseData.apiCallWrapper(
      serviceApi.servicePingGet(),
      logMessage: "Checking if device is online",
    ).then((value) {
      return false; //
    }).onError((error, stackTrace) {
      return true;
    });
  }

  /// Retrieves the access token from the server.
  /// \returns a [AuthenticationCredentialsSingleton] containing the access token.
  /// \throws [AuthException] if the access token could not be retrieved.
  static FutureOr<AuthenticationCredentialsSingleton>
      _getAccessTokenFromApi() async {
    ApiClient api = RequestUtility.getApiWithAuth(
      AuthenticationCredentialsSingleton().refreshToken!.token,
      (await ApiBaseData.getURL()) as String,
    );
    AuthenticationApi authenticationApi = AuthenticationApi(api);

    var singleton = AuthenticationCredentialsSingleton();
    await ApiBaseData.apiCallWrapper(
      authenticationApi.authenticationRefreshAccessTokenPost(),
      logMessage: "Fetching Access Token",
    ).then((value) {
      singleton.accessToken = Token(
        token: value!.accessToken!.token!,
        tokenType: TokenType.accessToken,
        expiration: value.accessToken!.expiryTimestamp!,
      );
    }).onError((error, stackTrace) {
      throw AuthException("Failed to get access token");
    });

    if (singleton.areAuthenticationCredentialsAvailable()) {
      throw AuthException("Failed to get access token");
    }

    return singleton;
  }

  static Future<bool> loginWithoutUserName(String password) async {
    AuthenticationCredentialsSingleton singleton =
        await getAuthenticationCredentials();
    var encryptionKDF = await getEncryption(password);
    var passwordHash = sha256.convert(utf8.encode(encryptionKDF)).toString();

    if (singleton.validationHash == passwordHash ||
        password == singleton.encryptionKDF) {
      var isOffline = await AuthService.isOffline();
      if (singleton.accessToken == null &&
          !validateToken(
            timestamp: singleton.accessToken?.expiration,
            tokenType: TokenType.accessToken,
          ) &&
          !isOffline) {
        try {
          singleton = await _getAccessTokenFromApi();
        } on AuthException catch (_) {
          return false;
        }
      }
      softLogout();
      singleton.encryptionKDF =
          password == singleton.encryptionKDF ? password : encryptionKDF;
      return true;
    }
    return false;
  }

  static Future<bool> loginWithBiometrics() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    AuthenticationCredentialsSingleton singleton =
        await getAuthenticationCredentials();

    var password = await storage.read(key: "encryptionKDF");
    singleton.encryptionKDF = password;

    return loginWithoutUserName(password ?? "");
  }

  static Future<String> getEncryption(String value) async {
    String encryptionKDF = await Cryptography.getKDFBase64(
      masterPassword: value,
      salt: "${AuthenticationCredentialsSingleton().username}_encryption",
    );
    return encryptionKDF;
  }

  /// Validates the authentication token. If the token is invalid, the user is logged in again but only if the token is still in the valid range.
  ///
  /// \returns `true` if the token is invalid, `false` otherwise.
  ///
  /// [timestamp]: The timestamp.
  ///
  /// [tokenType]: The tokenType.
  static bool validateToken({
    required int? timestamp,
    required TokenType tokenType,
  }) {
    if (timestamp == null) return false;
    DateTime validUntil = DateTime.fromMicrosecondsSinceEpoch(
      (timestamp * 0.8).toInt(),
    );
    if (DateTime.now().isAfter(validUntil)) {
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
    required bool softLogout,
  }) async {
    // Store in RAM
    var singleton = AuthenticationCredentialsSingleton();
    singleton.encryptionKDF = encryptionKDF;
    singleton.username = username;
    singleton.softLogout = softLogout;
    singleton.skipSplashScreen = false;
    singleton.refreshToken = Token(
      token: refreshToken,
      tokenType: TokenType.refreshToken,
      expiration: refreshExpiration,
    );
    singleton.accessToken = Token(
      token: accessToken,
      tokenType: TokenType.accessToken,
      expiration: accessExpiration,
    );
    // Store in secure storage
    const storage = FlutterSecureStorage();
    if (await AuthUtils.checkBiometricAvailability()) {
      await storage.write(key: "encryptionKDF", value: encryptionKDF);
    }
    await storage.write(key: "username", value: username);
    String validationHash =
        sha256.convert(utf8.encode(encryptionKDF)).toString();
    await storage.write(key: "validationHash", value: validationHash);
    await storage.write(key: "refreshToken", value: refreshToken);
    await storage.write(
      key: "refreshExpiration",
      value: refreshExpiration.toString(),
    );
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
    await storage.deleteAll();
  }

  /// softLogout is used to indicate that the user has logged out without deleting the authentication data.
  /// This is useful to determine if the user should be redirected to the login page.
  static void softLogout() {
    var singleton = AuthenticationCredentialsSingleton();

    singleton.softLogout = true;
  }

  static void deleteSoftLogout() {
    var singleton = AuthenticationCredentialsSingleton();

    singleton.softLogout = false;
  }

  /// Checks if a soft logout is active.
  /// \returns `true` if a soft logout is active, `false` otherwise.
  ///
  /// A soft logout is active if the user has logged out without deleting the authentication data.
  /// This is useful to determine if the user should be redirected to the login page.
  static Future<bool> isSoftLogout() async {
    AuthenticationCredentialsSingleton singleton =
        await getAuthenticationCredentials();

    return singleton.softLogout;
  }

  static Future<void> setSkipSplashScreen(bool isSkipped) async {
    AuthenticationCredentialsSingleton singleton =
        await getAuthenticationCredentials();

    singleton.skipSplashScreen = isSkipped;
  }
}
