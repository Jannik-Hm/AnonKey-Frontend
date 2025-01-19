import 'package:anonkey_frontend/Utility/api_base_data.dart';
import 'package:anonkey_frontend/src/Credentials/credential_list.dart';
import 'package:anonkey_frontend/src/Credentials/list-entry/credential_detail_view.dart';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:flutter/material.dart';
import 'package:anonkey_frontend/src/Credentials/credential_data.dart';

class CreateCredentialWidget extends StatefulWidget {
  final List<Folder> availableFolders;
  final CredentialList credentials;
  final Function(Credential) addToCredentials;
  final String? currentFolderUuid;

  const CreateCredentialWidget({
    super.key,
    required this.availableFolders,
    required this.credentials,
    required this.addToCredentials,
    this.currentFolderUuid,
  });

  @override
  State<StatefulWidget> createState() => _CreateCredentialWidget();
}

class _CreateCredentialWidget extends State<CreateCredentialWidget> {
  Future<void> onSaveCallback(Credential credential) async {
    widget.addToCredentials(credential);
    if (context.mounted) {
      Navigator.of(context).pop(); // Close create Window
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => ApiBaseData.callFuncIfServerReachable(
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CredentialDetailWidget(
                credential: null,
                onSaveCallback: onSaveCallback,
                availableFolders: widget.availableFolders,
                currentFolderUuid: widget.currentFolderUuid,
              ),
            ),
          );
        },
        context: context,
      ),
      icon: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
