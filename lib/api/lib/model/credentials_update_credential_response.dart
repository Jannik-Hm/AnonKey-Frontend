//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CredentialsUpdateCredentialResponse {
  /// Returns a new [CredentialsUpdateCredentialResponse] instance.
  CredentialsUpdateCredentialResponse({
    this.uuid,
    this.password,
    this.passwordSalt,
    this.username,
    this.usernameSalt,
    this.websiteUrl,
    this.websiteUrlSalt,
    this.note,
    this.noteSalt,
    this.displayName,
    this.displayNameSalt,
    this.folderUuid,
    this.createdTimestamp,
    this.changedTimestamp,
    this.deletedTimestamp,
  });

  /// The UUID of the credential.
  String? uuid;

  /// The encrypted password to store.
  String? password;

  /// The salt of the stored password.
  String? passwordSalt;

  /// The encrypted username to store.
  String? username;

  /// The salt of the encrypted username.
  String? usernameSalt;

  /// The URL of the website the credential belongs to.
  String? websiteUrl;

  /// The WebsiteUrlSalt of the credetial
  String? websiteUrlSalt;

  /// A note attached to the credential.
  String? note;

  /// The NoteSalt  of the credetial
  String? noteSalt;

  /// The display name of the credential..
  String? displayName;

  /// The DisplayNameSalt of the credetial
  String? displayNameSalt;

  /// The UUID of the folder the credential is in.  Use NULL for no folder.
  String? folderUuid;

  /// The unix timestamp at which the credential was created.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? createdTimestamp;

  /// The unix timestamp at which the credential was last edited.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? changedTimestamp;

  /// The unix timestamp the credential was deleted at.
  int? deletedTimestamp;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CredentialsUpdateCredentialResponse &&
          other.uuid == uuid &&
          other.password == password &&
          other.passwordSalt == passwordSalt &&
          other.username == username &&
          other.usernameSalt == usernameSalt &&
          other.websiteUrl == websiteUrl &&
          other.websiteUrlSalt == websiteUrlSalt &&
          other.note == note &&
          other.noteSalt == noteSalt &&
          other.displayName == displayName &&
          other.displayNameSalt == displayNameSalt &&
          other.folderUuid == folderUuid &&
          other.createdTimestamp == createdTimestamp &&
          other.changedTimestamp == changedTimestamp &&
          other.deletedTimestamp == deletedTimestamp;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (uuid == null ? 0 : uuid!.hashCode) +
      (password == null ? 0 : password!.hashCode) +
      (passwordSalt == null ? 0 : passwordSalt!.hashCode) +
      (username == null ? 0 : username!.hashCode) +
      (usernameSalt == null ? 0 : usernameSalt!.hashCode) +
      (websiteUrl == null ? 0 : websiteUrl!.hashCode) +
      (websiteUrlSalt == null ? 0 : websiteUrlSalt!.hashCode) +
      (note == null ? 0 : note!.hashCode) +
      (noteSalt == null ? 0 : noteSalt!.hashCode) +
      (displayName == null ? 0 : displayName!.hashCode) +
      (displayNameSalt == null ? 0 : displayNameSalt!.hashCode) +
      (folderUuid == null ? 0 : folderUuid!.hashCode) +
      (createdTimestamp == null ? 0 : createdTimestamp!.hashCode) +
      (changedTimestamp == null ? 0 : changedTimestamp!.hashCode) +
      (deletedTimestamp == null ? 0 : deletedTimestamp!.hashCode);

  @override
  String toString() =>
      'CredentialsUpdateCredentialResponse[uuid=$uuid, password=$password, passwordSalt=$passwordSalt, username=$username, usernameSalt=$usernameSalt, websiteUrl=$websiteUrl, websiteUrlSalt=$websiteUrlSalt, note=$note, noteSalt=$noteSalt, displayName=$displayName, displayNameSalt=$displayNameSalt, folderUuid=$folderUuid, createdTimestamp=$createdTimestamp, changedTimestamp=$changedTimestamp, deletedTimestamp=$deletedTimestamp]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.uuid != null) {
      json[r'uuid'] = this.uuid;
    } else {
      json[r'uuid'] = null;
    }
    if (this.password != null) {
      json[r'password'] = this.password;
    } else {
      json[r'password'] = null;
    }
    if (this.passwordSalt != null) {
      json[r'passwordSalt'] = this.passwordSalt;
    } else {
      json[r'passwordSalt'] = null;
    }
    if (this.username != null) {
      json[r'username'] = this.username;
    } else {
      json[r'username'] = null;
    }
    if (this.usernameSalt != null) {
      json[r'usernameSalt'] = this.usernameSalt;
    } else {
      json[r'usernameSalt'] = null;
    }
    if (this.websiteUrl != null) {
      json[r'websiteUrl'] = this.websiteUrl;
    } else {
      json[r'websiteUrl'] = null;
    }
    if (this.websiteUrlSalt != null) {
      json[r'websiteUrlSalt'] = this.websiteUrlSalt;
    } else {
      json[r'websiteUrlSalt'] = null;
    }
    if (this.note != null) {
      json[r'note'] = this.note;
    } else {
      json[r'note'] = null;
    }
    if (this.noteSalt != null) {
      json[r'noteSalt'] = this.noteSalt;
    } else {
      json[r'noteSalt'] = null;
    }
    if (this.displayName != null) {
      json[r'displayName'] = this.displayName;
    } else {
      json[r'displayName'] = null;
    }
    if (this.displayNameSalt != null) {
      json[r'displayNameSalt'] = this.displayNameSalt;
    } else {
      json[r'displayNameSalt'] = null;
    }
    if (this.folderUuid != null) {
      json[r'folderUuid'] = this.folderUuid;
    } else {
      json[r'folderUuid'] = null;
    }
    if (this.createdTimestamp != null) {
      json[r'createdTimestamp'] = this.createdTimestamp;
    } else {
      json[r'createdTimestamp'] = null;
    }
    if (this.changedTimestamp != null) {
      json[r'changedTimestamp'] = this.changedTimestamp;
    } else {
      json[r'changedTimestamp'] = null;
    }
    if (this.deletedTimestamp != null) {
      json[r'deletedTimestamp'] = this.deletedTimestamp;
    } else {
      json[r'deletedTimestamp'] = null;
    }
    return json;
  }

  /// Returns a new [CredentialsUpdateCredentialResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CredentialsUpdateCredentialResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "CredentialsUpdateCredentialResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "CredentialsUpdateCredentialResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CredentialsUpdateCredentialResponse(
        uuid: mapValueOfType<String>(json, r'uuid'),
        password: mapValueOfType<String>(json, r'password'),
        passwordSalt: mapValueOfType<String>(json, r'passwordSalt'),
        username: mapValueOfType<String>(json, r'username'),
        usernameSalt: mapValueOfType<String>(json, r'usernameSalt'),
        websiteUrl: mapValueOfType<String>(json, r'websiteUrl'),
        websiteUrlSalt: mapValueOfType<String>(json, r'websiteUrlSalt'),
        note: mapValueOfType<String>(json, r'note'),
        noteSalt: mapValueOfType<String>(json, r'noteSalt'),
        displayName: mapValueOfType<String>(json, r'displayName'),
        displayNameSalt: mapValueOfType<String>(json, r'displayNameSalt'),
        folderUuid: mapValueOfType<String>(json, r'folderUuid'),
        createdTimestamp: mapValueOfType<int>(json, r'createdTimestamp'),
        changedTimestamp: mapValueOfType<int>(json, r'changedTimestamp'),
        deletedTimestamp: mapValueOfType<int>(json, r'deletedTimestamp'),
      );
    }
    return null;
  }

  static List<CredentialsUpdateCredentialResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CredentialsUpdateCredentialResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CredentialsUpdateCredentialResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CredentialsUpdateCredentialResponse> mapFromJson(
      dynamic json) {
    final map = <String, CredentialsUpdateCredentialResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CredentialsUpdateCredentialResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CredentialsUpdateCredentialResponse-objects as value to a dart map
  static Map<String, List<CredentialsUpdateCredentialResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CredentialsUpdateCredentialResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CredentialsUpdateCredentialResponse.listFromJson(
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
