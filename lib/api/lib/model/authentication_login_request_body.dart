//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AuthenticationLoginRequestBody {
  /// Returns a new [AuthenticationLoginRequestBody] instance.
  AuthenticationLoginRequestBody({
    this.userName,
    this.kdfPasswordResult,
  });

  /// The name of the user to log in.
  String? userName;

  /// The result of the KDF function of the user's password.
  String? kdfPasswordResult;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthenticationLoginRequestBody &&
          other.userName == userName &&
          other.kdfPasswordResult == kdfPasswordResult;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (userName == null ? 0 : userName!.hashCode) +
      (kdfPasswordResult == null ? 0 : kdfPasswordResult!.hashCode);

  @override
  String toString() =>
      'AuthenticationLoginRequestBody[userName=$userName, kdfPasswordResult=$kdfPasswordResult]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.userName != null) {
      json[r'userName'] = this.userName;
    } else {
      json[r'userName'] = null;
    }
    if (this.kdfPasswordResult != null) {
      json[r'kdfPasswordResult'] = this.kdfPasswordResult;
    } else {
      json[r'kdfPasswordResult'] = null;
    }
    return json;
  }

  /// Returns a new [AuthenticationLoginRequestBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AuthenticationLoginRequestBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "AuthenticationLoginRequestBody[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "AuthenticationLoginRequestBody[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AuthenticationLoginRequestBody(
        userName: mapValueOfType<String>(json, r'userName'),
        kdfPasswordResult: mapValueOfType<String>(json, r'kdfPasswordResult'),
      );
    }
    return null;
  }

  static List<AuthenticationLoginRequestBody> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <AuthenticationLoginRequestBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AuthenticationLoginRequestBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AuthenticationLoginRequestBody> mapFromJson(dynamic json) {
    final map = <String, AuthenticationLoginRequestBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AuthenticationLoginRequestBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AuthenticationLoginRequestBody-objects as value to a dart map
  static Map<String, List<AuthenticationLoginRequestBody>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<AuthenticationLoginRequestBody>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AuthenticationLoginRequestBody.listFromJson(
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
