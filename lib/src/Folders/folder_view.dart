import 'package:anonkey_frontend/src/Credentials/create_credential_widget.dart';
import 'package:anonkey_frontend/src/Credentials/credential_data.dart';
import 'package:anonkey_frontend/src/Credentials/credential_list_view.dart';
import 'package:flutter/material.dart';

class FolderView extends StatefulWidget {
  final CredentialListWidgetData data;

  const FolderView({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _FolderView();
}

class _FolderView extends State<FolderView> {
  late CredentialListWidgetData data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  void addToCredentials(Credential credential) {
    setState(() {
      data.credentials.add(credential);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.availableFolders?.byIDList[data.currentFolderUuid]?.displayName ?? ""),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          CreateCredentialWidget(
            availableFolders: data.availableFolders?.byIDList.values.toList() ?? [],
            credentials: data.credentials,
            addToCredentials: addToCredentials,
            currentFolderUuid: data.currentFolderUuid,
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: CredentialListWidget(
              key: UniqueKey(),
              availableFolders: data.availableFolders,
              credentials: data.credentials,
              currentFolderUuid: data.currentFolderUuid,
            ),
          ),
        ],
      ),
    );
  }
}
