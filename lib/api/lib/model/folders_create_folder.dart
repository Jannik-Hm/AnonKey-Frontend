//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FoldersCreateFolder {
  /// Returns a new [FoldersCreateFolder] instance.
  FoldersCreateFolder({
    this.name,
    this.icon,
  });

  /// Name of the new folder.
  String? name;

  /// Icon of the new folder.
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
      other is FoldersCreateFolder && other.name == name && other.icon == icon;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (name == null ? 0 : name!.hashCode) + (icon == null ? 0 : icon!.hashCode);

  @override
  String toString() => 'FoldersCreateFolder[name=$name, icon=$icon]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
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

  /// Returns a new [FoldersCreateFolder] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FoldersCreateFolder? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "FoldersCreateFolder[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "FoldersCreateFolder[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FoldersCreateFolder(
        name: mapValueOfType<String>(json, r'name'),
        icon: mapValueOfType<int>(json, r'icon'),
      );
    }
    return null;
  }

  static List<FoldersCreateFolder> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <FoldersCreateFolder>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FoldersCreateFolder.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FoldersCreateFolder> mapFromJson(dynamic json) {
    final map = <String, FoldersCreateFolder>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FoldersCreateFolder.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FoldersCreateFolder-objects as value to a dart map
  static Map<String, List<FoldersCreateFolder>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<FoldersCreateFolder>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FoldersCreateFolder.listFromJson(
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
