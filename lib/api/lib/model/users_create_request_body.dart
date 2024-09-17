//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UsersCreateRequestBody {
  /// Returns a new [UsersCreateRequestBody] instance.
  UsersCreateRequestBody({
    this.userName,
    this.userDisplayName,
    this.kdfPasswordResult,
  });

  /// Name of the user to be created.
  String? userName;

  /// Display name of the user to be created.
  String? userDisplayName;

  /// Result of the KDF for the user password.
  String? kdfPasswordResult;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersCreateRequestBody &&
          other.userName == userName &&
          other.userDisplayName == userDisplayName &&
          other.kdfPasswordResult == kdfPasswordResult;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (userName == null ? 0 : userName!.hashCode) +
      (userDisplayName == null ? 0 : userDisplayName!.hashCode) +
      (kdfPasswordResult == null ? 0 : kdfPasswordResult!.hashCode);

  @override
  String toString() =>
      'UsersCreateRequestBody[userName=$userName, userDisplayName=$userDisplayName, kdfPasswordResult=$kdfPasswordResult]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.userName != null) {
      json[r'userName'] = this.userName;
    } else {
      json[r'userName'] = null;
    }
    if (this.userDisplayName != null) {
      json[r'userDisplayName'] = this.userDisplayName;
    } else {
      json[r'userDisplayName'] = null;
    }
    if (this.kdfPasswordResult != null) {
      json[r'kdfPasswordResult'] = this.kdfPasswordResult;
    } else {
      json[r'kdfPasswordResult'] = null;
    }
    return json;
  }

  /// Returns a new [UsersCreateRequestBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UsersCreateRequestBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "UsersCreateRequestBody[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "UsersCreateRequestBody[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UsersCreateRequestBody(
        userName: mapValueOfType<String>(json, r'userName'),
        userDisplayName: mapValueOfType<String>(json, r'userDisplayName'),
        kdfPasswordResult: mapValueOfType<String>(json, r'kdfPasswordResult'),
      );
    }
    return null;
  }

  static List<UsersCreateRequestBody> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <UsersCreateRequestBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UsersCreateRequestBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UsersCreateRequestBody> mapFromJson(dynamic json) {
    final map = <String, UsersCreateRequestBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UsersCreateRequestBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UsersCreateRequestBody-objects as value to a dart map
  static Map<String, List<UsersCreateRequestBody>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<UsersCreateRequestBody>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UsersCreateRequestBody.listFromJson(
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
