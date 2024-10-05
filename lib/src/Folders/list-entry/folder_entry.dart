import 'package:anonkey_frontend/src/Credentials/credential_list.dart';
import 'package:anonkey_frontend/src/Credentials/credential_list_view.dart';
import 'package:anonkey_frontend/src/Folders/folder_list.dart';
import 'package:anonkey_frontend/src/Folders/list-entry/folder_edit.dart';
import 'package:flutter/material.dart';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:go_router/go_router.dart';

//Usage: CredentialEntry(websiteUrl: "https://google.de", username: "jannik", password: "test", displayName: "Google", uuid: '', passwordSalt: '', usernameSalt: '', note: '', folderUuid: '', createdTimeStamp: '', changedTimeStamp: '', deletedTimeStamp: '',),

class FolderEntry extends StatefulWidget {
  final Folder folder;
  final CredentialList credentials;
  final FolderList? availableFolders;
  final Function(String uuid)? onDeleteCallback;

  const FolderEntry({
    super.key,
    required this.folder,
    required this.credentials,
    this.availableFolders,
    this.onDeleteCallback,
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

  void updateIcon({required int codePoint}) {
    setState(() {
      _folder.setIcon(codePoint: codePoint);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        context.push('/folder', extra: CredentialListWidgetData(availableFolders: widget.availableFolders, credentials: widget.credentials, currentFolderUuid: widget.folder.uuid!)),
      },
      child: Ink(
        padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 5.0),
        color: Theme.of(context).colorScheme.tertiary,
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure even spacing
            children: [
              // Image on the left
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 70.0),
                child: _folder.getIcon(color: Theme.of(context).colorScheme.onPrimary),
              ),
              const SizedBox(
                width: 20.0,
              ),
              // Vertically stacked texts in the middle
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add some spacing between the image and text
                  child: Text(
                    _folder.displayName,
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary, // Set the primary color from ColorScheme
                ),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FolderEditWidget(
                        folder: _folder,
                        iconCallback: updateIcon,
                        onDeleteCallback: widget.onDeleteCallback,
                      ),
                    ),
                  )
                },
                child: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  TODO: add button for creation of new Folders
//  with action:
/*
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FolderEditWidget(
              onSaveCallback: ({required folderData}) {
                //TODO: do something with created folderData
              },
            ),
          ),
        )
*/
