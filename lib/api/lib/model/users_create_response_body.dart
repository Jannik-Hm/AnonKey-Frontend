//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UsersCreateResponseBody {
  /// Returns a new [UsersCreateResponseBody] instance.
  UsersCreateResponseBody({
    this.token,
    this.expiresInSeconds,
  });

  /// The token that can be used for authentication.
  String? token;

  /// The time in seconds the token expires in.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? expiresInSeconds;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersCreateResponseBody &&
          other.token == token &&
          other.expiresInSeconds == expiresInSeconds;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (token == null ? 0 : token!.hashCode) +
      (expiresInSeconds == null ? 0 : expiresInSeconds!.hashCode);

  @override
  String toString() =>
      'UsersCreateResponseBody[token=$token, expiresInSeconds=$expiresInSeconds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.token != null) {
      json[r'token'] = this.token;
    } else {
      json[r'token'] = null;
    }
    if (this.expiresInSeconds != null) {
      json[r'expiresInSeconds'] = this.expiresInSeconds;
    } else {
      json[r'expiresInSeconds'] = null;
    }
    return json;
  }

  /// Returns a new [UsersCreateResponseBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UsersCreateResponseBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "UsersCreateResponseBody[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "UsersCreateResponseBody[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UsersCreateResponseBody(
        token: mapValueOfType<String>(json, r'token'),
        expiresInSeconds: mapValueOfType<int>(json, r'expiresInSeconds'),
      );
    }
    return null;
  }

  static List<UsersCreateResponseBody> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <UsersCreateResponseBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UsersCreateResponseBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UsersCreateResponseBody> mapFromJson(dynamic json) {
    final map = <String, UsersCreateResponseBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UsersCreateResponseBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UsersCreateResponseBody-objects as value to a dart map
  static Map<String, List<UsersCreateResponseBody>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<UsersCreateResponseBody>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UsersCreateResponseBody.listFromJson(
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
