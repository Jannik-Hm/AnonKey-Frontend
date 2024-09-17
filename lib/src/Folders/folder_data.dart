import 'package:flutter/material.dart';
import 'package:anonkey_frontend/api/lib/api.dart' as api;

class Folder {
  int _iconData;
  String displayName;
  String? uuid;

  Folder({required int iconData, required this.displayName, required this.uuid}) : _iconData = iconData;

  static Folder? fromSingleApi({required api.FoldersGetResponseBody response}) {
    api.FoldersGetFolder? folder = response.folder;
    if (folder == null) {
      return null;
    } else {
      return Folder(displayName: folder.name!, iconData: folder.icon!, uuid: folder.uuid!);
    }
  }

  static List<Folder>? fromAllApi({required api.FoldersGetAllResponseBody folders}) {
    return folders.folder?.map((folder) {
      return Folder(displayName: folder.name!, iconData: folder.icon!, uuid: folder.uuid!);
    }).toList();
  }

  Icon getIcon({required Color color}) {
    return Icon(
      IconData(this._iconData, fontFamily: 'MaterialIcons'),
      color: color,
    );
  }

  api.FoldersCreateFolder createFolder() {
    return api.FoldersCreateFolder(
      icon: this._iconData,
      name: this.displayName,
    );
  }

  api.FoldersUpdateFolder updateFolder() {
    return api.FoldersUpdateFolder(
      icon: this._iconData,
      name: this.displayName,
      uuid: this.uuid,
    );
  }
}
