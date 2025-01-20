import 'package:anonkey_frontend/src/Credentials/credential_list.dart';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:anonkey_frontend/src/Folders/folder_list.dart';
import 'package:anonkey_frontend/src/Folders/list-entry/folder_entry.dart';
import 'package:flutter/material.dart';

class FolderListWidgetData {
  final FolderList folders;
  final CredentialList credentials;

  FolderListWidgetData({
    required this.folders,
    required this.credentials,
  });
}

class FolderListWidget extends StatefulWidget {
  final FolderList folders;
  final CredentialList credentials;
  final Function(bool recursive) onDeleteCallback;

  const FolderListWidget({
    super.key,
    required this.folders,
    required this.credentials,
    required this.onDeleteCallback,
  });

  @override
  State<StatefulWidget> createState() => _FolderListWidget();
}

class _FolderListWidget extends State<FolderListWidget> {
  final double spacing = 16.0;

  late FolderList folders;

  late List<Folder> folderList;

  FolderEntry _fromList(Folder folder) {
    return FolderEntry(
      key: UniqueKey(),
      folder: folder,
      availableFolders: widget.folders,
      credentials: widget.credentials,
      onDeleteCallback: ({required bool recursive, required String uuid}) {
        setState(() {
          folders.remove(uuid);
          folderList = folders.byIDList.values.toList();
          widget.onDeleteCallback(recursive);
        });
      },
      onSaveCallback: ({required folderData}) {
        setState(() {
          folders.updateFromLocalObject(folder: folderData);
          folderList = folders.byIDList.values.toList();
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    folders = widget.folders;
    folderList = folders.byIDList.values.toList();
    // Initialize the mutable object from the widget field
  }

  @override
  Widget build(BuildContext context) {
    folderList.sort((x, y) => x.displayName.compareTo(y.displayName));
    return /* Expanded(
      child: */
        Column(children: folderList.map(_fromList).toList()) //,
        //)
        ;
  }
}
