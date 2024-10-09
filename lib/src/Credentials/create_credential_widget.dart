import 'package:anonkey_frontend/src/Credentials/credential_list.dart';
import 'package:anonkey_frontend/src/Credentials/list-entry/credential_detail_view.dart';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:flutter/material.dart';
import 'package:anonkey_frontend/src/Credentials/credential_data.dart';

class CreateCredentialWidget extends StatefulWidget {
  final List<Folder> availableFolders;
  final CredentialList credentials;
  final Function(Credential) addToCredentials;

  const CreateCredentialWidget({
    super.key,
    required this.availableFolders,
    required this.credentials,
    required this.addToCredentials,
  });

  @override
  State<StatefulWidget> createState() => _CreateCredentialWidget();
}

class _CreateCredentialWidget extends State<CreateCredentialWidget> {
  bool created = false;

  Future<void> onSaveCallback(Credential credential) async {
    if(!created) {
      widget.addToCredentials(credential);
      created = true;
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
      onPressed: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CredentialDetailWidget(
              credential: null,
              onSaveCallback: onSaveCallback,
              availableFolders: widget.availableFolders,
            ),
          ),
        )
      },
      icon: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}