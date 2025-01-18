//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UsersUpdateUser {
  /// Returns a new [UsersUpdateUser] instance.
  UsersUpdateUser({
    this.userName,
    this.displayName,
  });

  /// The username of the user to be updated.
  String? userName;

  /// The new display name of the user.
  String? displayName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersUpdateUser &&
          other.userName == userName &&
          other.displayName == displayName;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (userName == null ? 0 : userName!.hashCode) +
      (displayName == null ? 0 : displayName!.hashCode);

  @override
  String toString() =>
      'UsersUpdateUser[userName=$userName, displayName=$displayName]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.userName != null) {
      json[r'userName'] = this.userName;
    } else {
      json[r'userName'] = null;
    }
    if (this.displayName != null) {
      json[r'displayName'] = this.displayName;
    } else {
      json[r'displayName'] = null;
    }
    return json;
  }

  /// Returns a new [UsersUpdateUser] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UsersUpdateUser? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "UsersUpdateUser[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "UsersUpdateUser[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UsersUpdateUser(
        userName: mapValueOfType<String>(json, r'userName'),
        displayName: mapValueOfType<String>(json, r'displayName'),
      );
    }
    return null;
  }

  static List<UsersUpdateUser> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <UsersUpdateUser>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UsersUpdateUser.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UsersUpdateUser> mapFromJson(dynamic json) {
    final map = <String, UsersUpdateUser>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UsersUpdateUser.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UsersUpdateUser-objects as value to a dart map
  static Map<String, List<UsersUpdateUser>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<UsersUpdateUser>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UsersUpdateUser.listFromJson(
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
