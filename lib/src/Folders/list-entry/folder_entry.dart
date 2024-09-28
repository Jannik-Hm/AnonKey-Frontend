import 'dart:async';
import 'package:anonkey_frontend/src/Folders/list-entry/folder_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';

//Usage: CredentialEntry(websiteUrl: "https://google.de", username: "jannik", password: "test", displayName: "Google", uuid: '', passwordSalt: '', usernameSalt: '', note: '', folderUuid: '', createdTimeStamp: '', changedTimeStamp: '', deletedTimeStamp: '',),

class FolderEntry extends StatefulWidget {
  final Folder folder;

  const FolderEntry({
    super.key,
    required this.folder,
  });

  @override
  State<StatefulWidget> createState() => _FolderEntry();
}

class _FolderEntry extends State<FolderEntry> {
  Timer? _timer;
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
    void copyToClipboard({required String value, required String message}) {
      Clipboard.setData(ClipboardData(text: value)).then((_) {
        _timer?.cancel(); // Cancel any existing timer
        _timer = Timer(const Duration(seconds: 10), () async {
          ClipboardData? current = await Clipboard.getData('text/plain');
          if (current != null && current.text == value) {
            Clipboard.setData(const ClipboardData(text: ''));
          }
        });
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      });
    }

    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FolderEditWidget(folder: _folder, iconCallback: updateIcon,),
          ),
        )
      },
      child: Ink(
        padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 5.0),
        color: Theme.of(context).colorScheme.tertiary,
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start, // Ensure even spacing
            children: [
              // Image on the left
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 70.0),
                //child: Image.network("https://icons.duckduckgo.com/ip3/linustechtips.com.ico"),
                child: _folder.getIcon(color: Theme.of(context).colorScheme.onPrimary),
              ),
              const SizedBox(
                width: 20.0,
              ),
              // Vertically stacked texts in the middle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add some spacing between the image and text
                child: Text(
                  _folder.displayName,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
