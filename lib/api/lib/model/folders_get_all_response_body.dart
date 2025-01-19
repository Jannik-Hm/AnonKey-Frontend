//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FoldersGetAllResponseBody {
  /// Returns a new [FoldersGetAllResponseBody] instance.
  FoldersGetAllResponseBody({
    this.folder = const [],
  });

  /// Folders
  List<FoldersGetAllFolder>? folder;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoldersGetAllResponseBody &&
          _deepEquality.equals(other.folder, folder);

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (folder == null ? 0 : folder!.hashCode);

  @override
  String toString() => 'FoldersGetAllResponseBody[folder=$folder]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.folder != null) {
      json[r'folder'] = this.folder;
    } else {
      json[r'folder'] = null;
    }
    return json;
  }

  /// Returns a new [FoldersGetAllResponseBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FoldersGetAllResponseBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "FoldersGetAllResponseBody[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "FoldersGetAllResponseBody[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FoldersGetAllResponseBody(
        folder: FoldersGetAllFolder.listFromJson(json[r'folder']),
      );
    }
    return null;
  }

  static List<FoldersGetAllResponseBody> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <FoldersGetAllResponseBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FoldersGetAllResponseBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FoldersGetAllResponseBody> mapFromJson(dynamic json) {
    final map = <String, FoldersGetAllResponseBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FoldersGetAllResponseBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FoldersGetAllResponseBody-objects as value to a dart map
  static Map<String, List<FoldersGetAllResponseBody>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<FoldersGetAllResponseBody>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FoldersGetAllResponseBody.listFromJson(
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
