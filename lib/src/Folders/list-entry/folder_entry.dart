import 'package:anonkey_frontend/Utility/api_base_data.dart';
import 'package:anonkey_frontend/src/Credentials/credential_list.dart';
import 'package:anonkey_frontend/src/Credentials/credential_list_view.dart';
import 'package:anonkey_frontend/src/Folders/folder_list.dart';
import 'package:anonkey_frontend/src/Folders/list-entry/folder_edit.dart';
import 'package:anonkey_frontend/src/Widgets/clickable_tile.dart';
import 'package:flutter/material.dart';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:go_router/go_router.dart';

//Usage: CredentialEntry(websiteUrl: "https://google.de", username: "jannik", password: "test", displayName: "Google", uuid: '', passwordSalt: '', usernameSalt: '', note: '', folderUuid: '', createdTimeStamp: '', changedTimeStamp: '', deletedTimeStamp: '',),

class FolderEntry extends StatefulWidget {
  final Folder folder;
  final CredentialList credentials;
  final FolderList? availableFolders;
  final Function({required String uuid, required bool recursive})?
      onDeleteCallback;
  final Function({required Folder folderData})? onSaveCallback;

  const FolderEntry({
    super.key,
    required this.folder,
    required this.credentials,
    this.availableFolders,
    this.onDeleteCallback,
    this.onSaveCallback,
  });

  @override
  State<StatefulWidget> createState() => _FolderEntry();
}

class _FolderEntry extends State<FolderEntry> {
  late Folder _folder;

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _folder = widget.folder;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ClickableTile(
      onTap: () => {
        context.push('/folder',
            extra: CredentialListWidgetData(
                availableFolders: widget.availableFolders,
                credentials: widget.credentials,
                currentFolderUuid: widget.folder.uuid!)),
      },
      leading: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 70.0),
        child: _folder.getIcon(
          color: theme.colorScheme.onTertiary,
        ),
      ),
      title: Text(
        _folder.displayName,
        style: TextStyle(
          fontSize: 20.0,
          color: theme.colorScheme.onTertiary,
        ),
      ),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context)
              .colorScheme
              .primary, // Set the primary color from ColorScheme
        ),
        onPressed: () => {
          ApiBaseData.callFuncIfServerReachable(
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FolderEditWidget(
                    folder: _folder,
                    onDeleteCallback: widget.onDeleteCallback,
                    onSaveCallback: widget.onSaveCallback,
                  ),
                ),
              );
            },
            context: context,
          ),
        },
        child: Icon(
          Icons.edit,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
