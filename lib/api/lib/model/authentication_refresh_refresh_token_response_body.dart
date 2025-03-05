//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AuthenticationRefreshRefreshTokenResponseBody {
  /// Returns a new [AuthenticationRefreshRefreshTokenResponseBody] instance.
  AuthenticationRefreshRefreshTokenResponseBody({
    this.accessToken,
    this.refreshToken,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  AuthenticationRefreshRefreshToken? accessToken;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  AuthenticationRefreshRefreshToken? refreshToken;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthenticationRefreshRefreshTokenResponseBody &&
          other.accessToken == accessToken &&
          other.refreshToken == refreshToken;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (accessToken == null ? 0 : accessToken!.hashCode) +
      (refreshToken == null ? 0 : refreshToken!.hashCode);

  @override
  String toString() =>
      'AuthenticationRefreshRefreshTokenResponseBody[accessToken=$accessToken, refreshToken=$refreshToken]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.accessToken != null) {
      json[r'accessToken'] = this.accessToken;
    } else {
      json[r'accessToken'] = null;
    }
    if (this.refreshToken != null) {
      json[r'refreshToken'] = this.refreshToken;
    } else {
      json[r'refreshToken'] = null;
    }
    return json;
  }

  /// Returns a new [AuthenticationRefreshRefreshTokenResponseBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AuthenticationRefreshRefreshTokenResponseBody? fromJson(
      dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "AuthenticationRefreshRefreshTokenResponseBody[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "AuthenticationRefreshRefreshTokenResponseBody[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AuthenticationRefreshRefreshTokenResponseBody(
        accessToken:
            AuthenticationRefreshRefreshToken.fromJson(json[r'accessToken']),
        refreshToken:
            AuthenticationRefreshRefreshToken.fromJson(json[r'refreshToken']),
      );
    }
    return null;
  }

  static List<AuthenticationRefreshRefreshTokenResponseBody> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <AuthenticationRefreshRefreshTokenResponseBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value =
            AuthenticationRefreshRefreshTokenResponseBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AuthenticationRefreshRefreshTokenResponseBody> mapFromJson(
      dynamic json) {
    final map = <String, AuthenticationRefreshRefreshTokenResponseBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value =
            AuthenticationRefreshRefreshTokenResponseBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AuthenticationRefreshRefreshTokenResponseBody-objects as value to a dart map
  static Map<String, List<AuthenticationRefreshRefreshTokenResponseBody>>
      mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<AuthenticationRefreshRefreshTokenResponseBody>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] =
            AuthenticationRefreshRefreshTokenResponseBody.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{};
}
