import 'package:anonkey_frontend/src/Credentials/list-entry/logo.dart';
import 'package:flutter/material.dart';
import 'package:anonkey_frontend/src/Credentials/credential_data.dart';

class CredentialTrashEntry extends StatefulWidget {
  final Credential credential;

  const CredentialTrashEntry({
    super.key,
    required this.credential,
  });

  @override
  State<StatefulWidget> createState() => _CredentialTrashEntry();
}

class _CredentialTrashEntry extends State<CredentialTrashEntry> {
  late Credential _credential;

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _credential = widget.credential;
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () => {
        print("Restore Password PopUp"),
        //TODO: popup to ask wether to restore or delete forever
      },
      child: Ink(
        padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 5.0),
        color: Theme.of(context).colorScheme.tertiary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure even spacing
          children: [
            // Image on the left
            SizedBox(
              width: 40.0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 40.0, maxHeight: 40.0),
                child: getNetworkLogoFromUrl(_credential.getClearWebsiteUrl()),
              ),
            ),
            const SizedBox(
              width: 10.0,
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
          ],
        ),
      ),
    );
  }
}
