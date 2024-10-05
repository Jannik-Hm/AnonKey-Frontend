import 'package:anonkey_frontend/src/Credentials/credential_data.dart';
import 'package:anonkey_frontend/src/Credentials/credential_list.dart';
import 'package:anonkey_frontend/src/Credentials/list-entry/credential_entry.dart';
import 'package:anonkey_frontend/src/Folders/folder_list.dart';
import 'package:flutter/material.dart';

class CredentialListWidgetData {
  final CredentialList credentials;
  final String? currentFolderUuid;
  final FolderList? availableFolders;

  CredentialListWidgetData({
    required this.credentials,
    required this.currentFolderUuid,
    required this.availableFolders,
  });
}

class CredentialListWidget extends StatefulWidget {
  final CredentialList credentials;
  final String? currentFolderUuid;
  final FolderList? availableFolders;

///currentFolderUuid to null for All credentials, empty String for ungrouped and FolderUuid for special Folder
  const CredentialListWidget({
    super.key,
    required this.credentials,
    required this.availableFolders,
    this.currentFolderUuid,
  });

  @override
  State<StatefulWidget> createState() => _CredentialListWidget();
}

class _CredentialListWidget extends State<CredentialListWidget> {
  final double spacing = 16.0;

  late CredentialList credentials;

  late List<Credential> credentialList;

  CredentialEntry _fromList(Credential credential) {
    return CredentialEntry(
      key: UniqueKey(),
      credential: credential,
      onSaveCallback: (credential) {
        setState(() {
          credentials = credentials.updateFromLocalObject(credential: credential);
        });
      },
      availableFolders: widget.availableFolders!.toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    credentials = widget.credentials;
    credentialList = ((widget.currentFolderUuid == null) ? credentials.byIDList.values.toList() : (credentials.byFolderMap[widget.currentFolderUuid] ?? []));
    // Initialize the mutable object from the widget field
  }

  @override
  Widget build(BuildContext context) {
    credentialList.sort((x, y) => x.getClearDisplayName().compareTo(y.getClearDisplayName()));
    return Expanded(
      child: Column(children: credentialList.map(_fromList).toList()),
    );
  }
}
