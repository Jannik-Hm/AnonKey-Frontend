//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FoldersUpdateFolder {
  /// Returns a new [FoldersUpdateFolder] instance.
  FoldersUpdateFolder({
    this.uuid,
    this.name,
    this.icon,
  });

  /// UUID of the folder.
  String? uuid;

  /// Name of the folder.
  String? name;

  /// Icon of the folder.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? icon;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoldersUpdateFolder &&
          other.uuid == uuid &&
          other.name == name &&
          other.icon == icon;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (uuid == null ? 0 : uuid!.hashCode) +
      (name == null ? 0 : name!.hashCode) +
      (icon == null ? 0 : icon!.hashCode);

  @override
  String toString() =>
      'FoldersUpdateFolder[uuid=$uuid, name=$name, icon=$icon]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.uuid != null) {
      json[r'uuid'] = this.uuid;
    } else {
      json[r'uuid'] = null;
    }
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.icon != null) {
      json[r'icon'] = this.icon;
    } else {
      json[r'icon'] = null;
    }
    return json;
  }

  /// Returns a new [FoldersUpdateFolder] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FoldersUpdateFolder? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "FoldersUpdateFolder[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "FoldersUpdateFolder[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FoldersUpdateFolder(
        uuid: mapValueOfType<String>(json, r'uuid'),
        name: mapValueOfType<String>(json, r'name'),
        icon: mapValueOfType<int>(json, r'icon'),
      );
    }
    return null;
  }

  static List<FoldersUpdateFolder> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <FoldersUpdateFolder>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FoldersUpdateFolder.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FoldersUpdateFolder> mapFromJson(dynamic json) {
    final map = <String, FoldersUpdateFolder>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FoldersUpdateFolder.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FoldersUpdateFolder-objects as value to a dart map
  static Map<String, List<FoldersUpdateFolder>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<FoldersUpdateFolder>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FoldersUpdateFolder.listFromJson(
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
