//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AuthenticationRefreshRefreshToken {
  /// Returns a new [AuthenticationRefreshRefreshToken] instance.
  AuthenticationRefreshRefreshToken({
    this.token,
    this.tokenType,
    this.expiryTimestamp,
  });

  /// The token that can be used for authentication.
  String? token;

  /// The type of the token, either \"AccessToken\" or \"RefreshToken\"
  String? tokenType;

  /// The time in seconds the token expires on.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? expiryTimestamp;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthenticationRefreshRefreshToken &&
          other.token == token &&
          other.tokenType == tokenType &&
          other.expiryTimestamp == expiryTimestamp;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (token == null ? 0 : token!.hashCode) +
      (tokenType == null ? 0 : tokenType!.hashCode) +
      (expiryTimestamp == null ? 0 : expiryTimestamp!.hashCode);

  @override
  String toString() =>
      'AuthenticationRefreshRefreshToken[token=$token, tokenType=$tokenType, expiryTimestamp=$expiryTimestamp]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.token != null) {
      json[r'token'] = this.token;
    } else {
      json[r'token'] = null;
    }
    if (this.tokenType != null) {
      json[r'tokenType'] = this.tokenType;
    } else {
      json[r'tokenType'] = null;
    }
    if (this.expiryTimestamp != null) {
      json[r'expiryTimestamp'] = this.expiryTimestamp;
    } else {
      json[r'expiryTimestamp'] = null;
    }
    return json;
  }

  /// Returns a new [AuthenticationRefreshRefreshToken] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AuthenticationRefreshRefreshToken? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "AuthenticationRefreshRefreshToken[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "AuthenticationRefreshRefreshToken[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AuthenticationRefreshRefreshToken(
        token: mapValueOfType<String>(json, r'token'),
        tokenType: mapValueOfType<String>(json, r'tokenType'),
        expiryTimestamp: mapValueOfType<int>(json, r'expiryTimestamp'),
      );
    }
    return null;
  }

  static List<AuthenticationRefreshRefreshToken> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <AuthenticationRefreshRefreshToken>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AuthenticationRefreshRefreshToken.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AuthenticationRefreshRefreshToken> mapFromJson(
      dynamic json) {
    final map = <String, AuthenticationRefreshRefreshToken>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AuthenticationRefreshRefreshToken.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AuthenticationRefreshRefreshToken-objects as value to a dart map
  static Map<String, List<AuthenticationRefreshRefreshToken>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<AuthenticationRefreshRefreshToken>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AuthenticationRefreshRefreshToken.listFromJson(
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
