import 'package:flutter/material.dart';
import 'package:anonkey_frontend/api/lib/api.dart' as api;

class Folder {
  int _iconData;
  String displayName;
  String? uuid;

  Folder({required int iconData, required this.displayName, required this.uuid})
      : _iconData = iconData;

  @override
  String toString() {
    return """

    UUID: $uuid,
    Name: $displayName,
    IconCodePoint: $_iconData""";
  }

  Folder clone() {
    Folder origin = this;
    return Folder(
        displayName: origin.displayName,
        iconData: origin._iconData,
        uuid: origin.uuid);
  }

  /// Function to deserialize json Map into Folder
  static Folder fromJson(Map<String, dynamic> json) {
    return Folder(
      displayName: json["displayName"],
      iconData: json["iconData"],
      uuid: json["uuid"],
    );
  }

  /// Function to serialize Folder in json format
  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'iconData': getIconCodePoint(),
        'uuid': uuid,
      };

  /// Function to generate a Folder Object from `Single` Endpoint response
  static Folder? fromSingleApi({required api.FoldersGetResponseBody response}) {
    api.FoldersGetFolder? folder = response.folder;
    if (folder == null) {
      return null;
    } else {
      return Folder(
          displayName: folder.name!,
          iconData: folder.icon!,
          uuid: folder.uuid!);
    }
  }

  /// Function to get List<Folder> from `All` Endpoint response
  static List<Folder>? fromAllApi(
      {required api.FoldersGetAllResponseBody folders}) {
    return folders.folder?.map((folder) {
      return Folder(
          displayName: folder.name!,
          iconData: folder.icon!,
          uuid: folder.uuid!);
    }).toList();
  }

  /// Function to get Icon Widget
  Icon getIcon({required Color color}) {
    return Icon(
      IconData(this._iconData, fontFamily: 'MaterialIcons'),
      color: color,
    );
  }

  /// Function to set Icon Widget using codePoint
  void setIcon({required int codePoint}) {
    this._iconData = codePoint;
  }

  /// Function to get Icon codePoint
  int getIconCodePoint() {
    return this._iconData;
  }

  /// Function to get IconData
  IconData getIconData() {
    return IconData(this._iconData, fontFamily: "MaterialIcons");
  }

  /// Function to get Object for `Create` Endpoint using this data
  api.FoldersCreateFolder createFolder() {
    return api.FoldersCreateFolder(
      icon: this._iconData,
      name: this.displayName,
    );
  }

  /// Function to get Body for `Update` Endpoint using this data
  api.FoldersUpdateRequestBody updateFolderBody(
      {api.FoldersUpdateFolder? requestdata}) {
    return api.FoldersUpdateRequestBody(folder: requestdata ?? updateFolder());
  }

  /// Function to get Object for `Update` Endpoint using this data
  api.FoldersUpdateFolder updateFolder() {
    return api.FoldersUpdateFolder(
      icon: this._iconData,
      name: this.displayName,
      uuid: this.uuid,
    );
  }
}
