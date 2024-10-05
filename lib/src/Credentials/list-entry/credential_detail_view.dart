import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:anonkey_frontend/src/Widgets/folder_dropdown.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:anonkey_frontend/src/Widgets/entry_input.dart';
import 'package:anonkey_frontend/src/Credentials/credential_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CredentialDetailWidget extends StatefulWidget {
  final Credential credential;
  final List<Folder> availableFolders;
  final Function(Credential credential)? onSaveCallback;
  final Function(String uuid)? onSoftDeleteCallback;

  const CredentialDetailWidget({
    super.key,
    required this.credential,
    this.onSaveCallback,
    this.onSoftDeleteCallback,
    required this.availableFolders,
  });

  @override
  State<StatefulWidget> createState() => _CredentialDetailWidget();
}

class _CredentialDetailWidget extends State<CredentialDetailWidget> {
  final displayNameFocus = FocusNode();
  final passwordFocus = FocusNode();
  final usernameFocus = FocusNode();
  final websiteUrlFocus = FocusNode();
  final noteFocus = FocusNode();
  late bool _enabled;
  late bool _obscurePassword;
  late Credential _credential;
  final double spacing = 16.0;
  late String newFolderUUID;

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _enabled = false;
    _obscurePassword = true;
    _credential = widget.credential;
    newFolderUUID = _credential.folderUuid ?? "";
  }

  @override
  Widget build(BuildContext context) {
    //final uuid;
    final displayName = TextEditingController(text: _credential.getClearDisplayName());

    final password = TextEditingController(text: _credential.getClearPassword());
    //final passwordSalt;

    final username = TextEditingController(text: _credential.getClearUsername());
    //final usernameSalt;

    final websiteUrl = TextEditingController(text: _credential.getClearWebsiteUrl());

    final note = TextEditingController(text: _credential.getClearNote());

    void enableFields() {
      setState(() {
        _enabled = true;
        _obscurePassword = false;
      });
    }

    void disableFields() {
      setState(() {
        _enabled = false;
        _obscurePassword = true;
      });
    }

    Future<bool> save() async {
      String pass = (await AuthService.getAuthenticationCredentials())["password"]!;
      print(newFolderUUID);
      Credential temp = await _credential.updateFromLocal(
        masterPassword: pass,
        clearWebsiteUrl: websiteUrl.text,
        clearUsername: username.text,
        clearPassword: password.text,
        clearDisplayName: displayName.text,
        clearNote: note.text,
        folderUuid: newFolderUUID,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? url = prefs.getString('url');
      Map<String, String> authdata = await AuthService.getAuthenticationCredentials();
      if (url != null) {
        ApiClient apiClient = RequestUtility.getApiWithAuth(authdata["token"]!, url);
        CredentialsApi api = CredentialsApi(apiClient);
        print(temp.updateAPICredentialRequestBody());
        await api.credentialsUpdatePut(temp.updateAPICredentialRequestBody());
      }
      setState(() {
        _credential = temp;
      });
      if (widget.onSaveCallback != null) widget.onSaveCallback!(temp);
      return true;
    }

    Future<bool> delete() async {
      print(_credential.uuid);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? url = prefs.getString('url');
      Map<String, String> authdata = await AuthService.getAuthenticationCredentials();
      if (url != null) {
        ApiClient apiClient = RequestUtility.getApiWithAuth(authdata["token"]!, url);
        CredentialsApi api = CredentialsApi(apiClient);
        await api.credentialsSoftDeletePut(_credential.uuid);
      }
      if (widget.onSoftDeleteCallback != null) widget.onSoftDeleteCallback!(_credential.uuid);
      return true;
    }

    showDeleteConfirmDialog(Credential credential) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // Retrieve the text the that user has entered by using the
            // TextEditingController.
            title: Text(AppLocalizations.of(context)!.confirmCredentialDeleteTitle(credential.getClearDisplayName())),
            //content: Text('Are you sure you want to move Credential "${credential.getClearDisplayName()}" into the deleted Folder?'),
            content: Text(AppLocalizations.of(context)!.confirmCredentialDeleteText(credential.getClearDisplayName())),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        print("Abort");
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      child: const Text("Abort"),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        delete().then(
                          (value) {
                            print("Confirm");
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        );
                      },
                      style: TextButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                      child: const Text("Confirm"),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(_credential.getClearDisplayName()),
        actions: [
          if (!_enabled) IconButton(onPressed: () => enableFields(), icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.onPrimary)),
          if (_enabled)
            IconButton(
                onPressed: () => {
                      save().then(
                        (value) {
                          disableFields();
                        },
                      )
                    },
                icon: Icon(
                  Icons.save,
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
          if (_enabled)
            IconButton(
                onPressed: () => disableFields(),
                icon: Icon(
                  Icons.cancel,
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
          const SizedBox(
            width: 8.0,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDeleteConfirmDialog(_credential),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          children: [
            EntryInput(
              key: UniqueKey(),
              controller: displayName,
              label: 'Display Name',
              obscureText: false,
              focus: displayNameFocus,
              enabled: _enabled,
            ),
            SizedBox(height: spacing),
            EntryInput(
              key: UniqueKey(),
              controller: websiteUrl,
              label: 'URL',
              obscureText: false,
              focus: websiteUrlFocus,
              enabled: _enabled,
            ),
            SizedBox(height: spacing),
            EntryInput(
              key: UniqueKey(),
              controller: username,
              label: 'Username',
              obscureText: false,
              focus: usernameFocus,
              enabled: _enabled,
            ),
            SizedBox(height: spacing),
            EntryInput(
              key: UniqueKey(),
              controller: password,
              label: 'Password',
              obscureText: _obscurePassword,
              focus: passwordFocus,
              enabled: _enabled,
            ),
            SizedBox(height: spacing),
            //TODO: update Notes to multi-line Text Area
            EntryInput(
              key: UniqueKey(),
              controller: note,
              label: 'Notes',
              obscureText: false,
              focus: noteFocus,
              enabled: _enabled,
            ),
            SizedBox(height: spacing),
            FolderDropdown(
              key: UniqueKey(),
              folders: widget.availableFolders,
              enabled: _enabled,
              currentFolderUuid: _credential.folderUuid ?? "",
              onChangeCallback: (value) {
                newFolderUUID = value ?? "";
              },
            ),
          ],
        ),
      ),
    );
  }
}
