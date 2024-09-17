//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AuthenticationChangePasswordRequestBody {
  /// Returns a new [AuthenticationChangePasswordRequestBody] instance.
  AuthenticationChangePasswordRequestBody({
    this.kdfResultOldPassword,
    this.kdfResultNewPassword,
  });

  /// The KDF result of the old password.
  String? kdfResultOldPassword;

  /// The new KDF result that should be used from now on.
  String? kdfResultNewPassword;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthenticationChangePasswordRequestBody &&
          other.kdfResultOldPassword == kdfResultOldPassword &&
          other.kdfResultNewPassword == kdfResultNewPassword;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (kdfResultOldPassword == null ? 0 : kdfResultOldPassword!.hashCode) +
      (kdfResultNewPassword == null ? 0 : kdfResultNewPassword!.hashCode);

  @override
  String toString() =>
      'AuthenticationChangePasswordRequestBody[kdfResultOldPassword=$kdfResultOldPassword, kdfResultNewPassword=$kdfResultNewPassword]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.kdfResultOldPassword != null) {
      json[r'kdfResultOldPassword'] = this.kdfResultOldPassword;
    } else {
      json[r'kdfResultOldPassword'] = null;
    }
    if (this.kdfResultNewPassword != null) {
      json[r'kdfResultNewPassword'] = this.kdfResultNewPassword;
    } else {
      json[r'kdfResultNewPassword'] = null;
    }
    return json;
  }

  /// Returns a new [AuthenticationChangePasswordRequestBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AuthenticationChangePasswordRequestBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "AuthenticationChangePasswordRequestBody[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "AuthenticationChangePasswordRequestBody[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AuthenticationChangePasswordRequestBody(
        kdfResultOldPassword:
            mapValueOfType<String>(json, r'kdfResultOldPassword'),
        kdfResultNewPassword:
            mapValueOfType<String>(json, r'kdfResultNewPassword'),
      );
    }
    return null;
  }

  static List<AuthenticationChangePasswordRequestBody> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <AuthenticationChangePasswordRequestBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AuthenticationChangePasswordRequestBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AuthenticationChangePasswordRequestBody> mapFromJson(
      dynamic json) {
    final map = <String, AuthenticationChangePasswordRequestBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value =
            AuthenticationChangePasswordRequestBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AuthenticationChangePasswordRequestBody-objects as value to a dart map
  static Map<String, List<AuthenticationChangePasswordRequestBody>>
      mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<AuthenticationChangePasswordRequestBody>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AuthenticationChangePasswordRequestBody.listFromJson(
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
