//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ErrorResponseBody {
  /// Returns a new [ErrorResponseBody] instance.
  ErrorResponseBody({
    this.message,
    this.detail,
<<<<<<< HEAD
    this.internalCode,
=======
>>>>>>> 7a4a85b (Swagger api)
  });

  /// The short message describing the error.
  String? message;

  /// A detailed explanation detailing the error.
  String? detail;

<<<<<<< HEAD
  /// The error code for error correction purposes.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? internalCode;

=======
>>>>>>> 7a4a85b (Swagger api)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorResponseBody &&
          other.message == message &&
<<<<<<< HEAD
          other.detail == detail &&
          other.internalCode == internalCode;
=======
          other.detail == detail;
>>>>>>> 7a4a85b (Swagger api)

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (message == null ? 0 : message!.hashCode) +
<<<<<<< HEAD
      (detail == null ? 0 : detail!.hashCode) +
      (internalCode == null ? 0 : internalCode!.hashCode);

  @override
  String toString() =>
      'ErrorResponseBody[message=$message, detail=$detail, internalCode=$internalCode]';
=======
      (detail == null ? 0 : detail!.hashCode);

  @override
  String toString() => 'ErrorResponseBody[message=$message, detail=$detail]';
>>>>>>> 7a4a85b (Swagger api)

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.message != null) {
      json[r'message'] = this.message;
    } else {
      json[r'message'] = null;
    }
    if (this.detail != null) {
      json[r'detail'] = this.detail;
    } else {
      json[r'detail'] = null;
    }
<<<<<<< HEAD
    if (this.internalCode != null) {
      json[r'internalCode'] = this.internalCode;
    } else {
      json[r'internalCode'] = null;
    }
=======
>>>>>>> 7a4a85b (Swagger api)
    return json;
  }

  /// Returns a new [ErrorResponseBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ErrorResponseBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "ErrorResponseBody[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "ErrorResponseBody[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ErrorResponseBody(
        message: mapValueOfType<String>(json, r'message'),
        detail: mapValueOfType<String>(json, r'detail'),
<<<<<<< HEAD
        internalCode: mapValueOfType<int>(json, r'internalCode'),
=======
>>>>>>> 7a4a85b (Swagger api)
      );
    }
    return null;
  }

  static List<ErrorResponseBody> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ErrorResponseBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ErrorResponseBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ErrorResponseBody> mapFromJson(dynamic json) {
    final map = <String, ErrorResponseBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ErrorResponseBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ErrorResponseBody-objects as value to a dart map
  static Map<String, List<ErrorResponseBody>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ErrorResponseBody>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ErrorResponseBody.listFromJson(
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
