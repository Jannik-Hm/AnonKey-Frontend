import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './logo.dart';
import './credential_detail_view.dart';
import './../credential_data.dart';

//Usage: CredentialEntry(websiteUrl: "https://google.de", username: "jannik", password: "test", displayName: "Google", uuid: '', passwordSalt: '', usernameSalt: '', note: '', folderUuid: '', createdTimeStamp: '', changedTimeStamp: '', deletedTimeStamp: '',),

class CredentialEntry extends StatefulWidget {
  Credential credential;

  CredentialEntry({
    super.key,
    required this.credential,
  });

  @override
  State<StatefulWidget> createState() => _CredentialEntry();
}

class _CredentialEntry extends State<CredentialEntry> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CredentialDetailWidget(credential: widget.credential),
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
              child: getNetworkLogoFromUrl(widget.credential.websiteUrl),
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
                      widget.credential.displayName,
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      widget.credential.username,
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
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: widget.credential.username));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copied Username'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
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
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: widget.credential.password));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copied Password'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
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
