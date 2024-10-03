import 'dart:async';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './logo.dart';
import './credential_detail_view.dart';
import 'package:anonkey_frontend/src/Credentials/credential_data.dart';

//Usage: CredentialEntry(websiteUrl: "https://google.de", username: "jannik", password: "test", displayName: "Google", uuid: '', passwordSalt: '', usernameSalt: '', note: '', folderUuid: '', createdTimeStamp: '', changedTimeStamp: '', deletedTimeStamp: '',),

class CredentialEntry extends StatefulWidget {
  final Credential credential;
  final List<Folder> availableFolders;
  final Function(Credential credential)? onSaveCallback;

  const CredentialEntry({
    super.key,
    required this.credential,
    this.onSaveCallback,
    required this.availableFolders,
  });

  @override
  State<StatefulWidget> createState() => _CredentialEntry();
}

class _CredentialEntry extends State<CredentialEntry> {
  Timer? _timer;
  late Credential _credential;

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _credential = widget.credential;
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

    //Credential.newEntry(clearPassword: "12345678", clearDisplayName: "Test", folderUuid: "123", masterPassword: "SuperSicher", clearUsername: "test", uuid: "balabadasda", clearWebsiteUrl: "google.de", clearNote: "", createdTimeStamp: 0);

    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CredentialDetailWidget(
              credential: _credential,
              onSaveCallback: widget.onSaveCallback,
              availableFolders: widget.availableFolders,
            ),
          ),
        )
      },
      child: Ink(
        padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 5.0),
        color: Theme.of(context).colorScheme.tertiary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure even spacing
          children: [
            // Image on the left
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 70.0),
              //child: Image.network("https://icons.duckduckgo.com/ip3/linustechtips.com.ico"),
              child: getNetworkLogoFromUrl(_credential.getClearWebsiteUrl()),
            ),
            const SizedBox(
              width: 20.0,
            ),
            // Vertically stacked texts in the middle
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add some spacing between the image and text
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                  children: [
                    Text(
                      _credential.getClearDisplayName(),
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      _credential.getClearUsername(),
                      style: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary, // Set the primary color from ColorScheme
              ),
              onPressed: () => copyToClipboard(message: 'Copied Username', value: _credential.getClearUsername()),
              /* onPressed: () async {
                await Clipboard.setData(ClipboardData(text: _credential.username));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copied Username'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              }, */
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 8.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary, // Set the primary color from ColorScheme
              ),
              onPressed: () => copyToClipboard(message: 'Copied Password', value: _credential.getClearPassword()),
              /* onPressed: () async {
                await Clipboard.setData(ClipboardData(text: _credential.password));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copied Password'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              }, */
              child: Icon(
                Icons.password,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
