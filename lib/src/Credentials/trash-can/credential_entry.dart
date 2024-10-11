import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/Credentials/list-entry/logo.dart';
import 'package:anonkey_frontend/src/Widgets/clickable_tile.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:anonkey_frontend/src/Credentials/credential_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CredentialTrashEntry extends StatefulWidget {
  final Credential credential;
  final Function(Credential) onRestoreCallback;
  final Function(Credential) onDeleteForeverCallback;

  const CredentialTrashEntry({
    super.key,
    required this.credential,
    required this.onRestoreCallback,
    required this.onDeleteForeverCallback,
  });

  @override
  State<StatefulWidget> createState() => _CredentialTrashEntry();
}

class _CredentialTrashEntry extends State<CredentialTrashEntry> {
  late Credential _credential;

  Future<void> restore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? url = prefs.getString('url');
    Map<String, String> authdata = await AuthService.getAuthenticationCredentials();
    if (url != null) {
      ApiClient apiClient = RequestUtility.getApiWithAuth(authdata["token"]!, url);
      CredentialsApi api = CredentialsApi(apiClient);
      await api.credentialsSoftUndeletePut(_credential.uuid);
    }
  }

  Future<void> deleteForever() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? url = prefs.getString('url');
    Map<String, String> authdata = await AuthService.getAuthenticationCredentials();
    if (url != null) {
      ApiClient apiClient = RequestUtility.getApiWithAuth(authdata["token"]!, url);
      CredentialsApi api = CredentialsApi(apiClient);
      await api.credentialsDeleteDelete(_credential.uuid);
    }
  }

  showDeleteConfirmDialog(Credential credential) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Retrieve the text the that user has entered by using the
          // TextEditingController.
          title: const Text("Restore or Delete forever?"),
          //content: Text('Are you sure you want to move Credential "${credential.getClearDisplayName()}" into the deleted Folder?'),
          content: const Text("Do you want to restore this Credential or delete forever?"),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      restore().then((value) {
                        widget.onRestoreCallback(_credential);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    style: TextButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: const Text("Restore"),
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      deleteForever().then((value) {
                        widget.onDeleteForeverCallback(_credential);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    style: TextButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: const Text("Delete forever"),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _credential = widget.credential;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ClickableTile(
      onTap: () => {
        showDeleteConfirmDialog(_credential),
      },
      leading: SizedBox(
        width: 40.0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 40.0, maxHeight: 40.0),
          child: getNetworkLogoFromUrl(_credential.getClearWebsiteUrl()),
        ),
      ),
      title: Text(
        _credential.getClearDisplayName(),
        style: TextStyle(
          fontSize: 20.0,
          color: theme.colorScheme.onPrimary,
        ),
      ),
      subTitle: Text(
        _credential.getClearUsername(),
        style: TextStyle(
          fontSize: 15.0,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );

    return InkWell(
      onTap: () => {
        showDeleteConfirmDialog(_credential),
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
