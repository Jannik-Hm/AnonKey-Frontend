//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UsersGetUser {
  /// Returns a new [UsersGetUser] instance.
  UsersGetUser({
    this.displayName,
  });

  /// The display name of the user.
  String? displayName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersGetUser && other.displayName == displayName;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (displayName == null ? 0 : displayName!.hashCode);

  @override
  String toString() => 'UsersGetUser[displayName=$displayName]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.displayName != null) {
      json[r'displayName'] = this.displayName;
    } else {
      json[r'displayName'] = null;
    }
    return json;
  }

  /// Returns a new [UsersGetUser] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UsersGetUser? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "UsersGetUser[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "UsersGetUser[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UsersGetUser(
        displayName: mapValueOfType<String>(json, r'displayName'),
      );
    }
    return null;
  }

  static List<UsersGetUser> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <UsersGetUser>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UsersGetUser.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UsersGetUser> mapFromJson(dynamic json) {
    final map = <String, UsersGetUser>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UsersGetUser.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UsersGetUser-objects as value to a dart map
  static Map<String, List<UsersGetUser>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<UsersGetUser>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UsersGetUser.listFromJson(
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
