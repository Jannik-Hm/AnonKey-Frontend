import 'dart:async';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:anonkey_frontend/src/Widgets/clickable_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './logo.dart';
import './credential_detail_view.dart';
import 'package:anonkey_frontend/src/Credentials/credential_data.dart';

class CredentialEntry extends StatefulWidget {
  final Credential credential;
  final List<Folder> availableFolders;
  final Function(Credential credential)? onSaveCallback;
  final Function(String uuid)? onSoftDeleteCallback;

  const CredentialEntry({
    super.key,
    required this.credential,
    this.onSaveCallback,
    this.onSoftDeleteCallback,
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
    ThemeData theme = Theme.of(context);
    return ClickableTile(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CredentialDetailWidget(
              credential: _credential,
              onSaveCallback: widget.onSaveCallback,
              onSoftDeleteCallback: widget.onSoftDeleteCallback,
              availableFolders: widget.availableFolders,
            ),
          ),
        )
      },
      leading: SizedBox(
        width: 40.0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 40.0, maxHeight: 40.0),
          //child: Image.network("https://icons.duckduckgo.com/ip3/linustechtips.com.ico"),
          child: getNetworkLogoFromUrl(_credential.getClearWebsiteUrl()),
        ),
      ),
      title: Text(
        _credential.getClearDisplayName(),
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 20.0,
        ),
      ),
      subTitle: Text(
        _credential.getClearUsername(),
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 15.0,
        ),
      ),
      trailing: Wrap(
        spacing: 8.0,
        children: [
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
    );
  }
}
