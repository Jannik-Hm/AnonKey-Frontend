import 'package:anonkey_frontend/src/Credentials/credential_list_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FolderView extends StatelessWidget {
  final CredentialListWidgetData data;

  const FolderView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              context.pushNamed("settings");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CredentialListWidget(availableFolders: data.availableFolders, credentials: data.credentials, currentFolderUuid: data.currentFolderUuid,),
        ],
      ),
    );
  }
}
