import 'dart:async';

import 'package:anonkey_frontend/Utility/api_base_data.dart';
import 'package:anonkey_frontend/Utility/notification_popup.dart';
import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:anonkey_frontend/src/Widgets/folder_dropdown.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:anonkey_frontend/src/Widgets/entry_input.dart';
import 'package:anonkey_frontend/src/Credentials/credential_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Widget for Editing and Displaying Credential Data
///
/// [credential] Credential Data to display, `null` for creating New
///
/// [availableFolders] List of Folders for Folder Selector Dropdown
///
/// [onSaveCallback] Callback triggered on Save
///
/// [onSoftDeleteCallback] Callback triggered on Soft Delete
///
/// [currentFolderUuid] Uuid of current Folder in Selector Dropdown, only relevant when credential is `null`
///
class CredentialDetailWidget extends StatefulWidget {
  final Credential? credential;
  final List<Folder> availableFolders;
  final Function(Credential credential)? onSaveCallback;
  final Function(String uuid)? onSoftDeleteCallback;
  final String? currentFolderUuid;

  const CredentialDetailWidget({
    super.key,
    required this.credential,
    this.onSaveCallback,
    this.onSoftDeleteCallback,
    required this.availableFolders,
    this.currentFolderUuid,
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
  late Credential? _credential;
  final double spacing = 16.0;
  late String newFolderUUID;

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _enabled = (widget.credential == null);
    _obscurePassword = !(widget.credential == null);
    _credential = widget.credential;
    newFolderUUID = (_credential == null)
        ? (widget.currentFolderUuid ?? "")
        : (_credential?.folderUuid ?? "");
  }

  @override
  Widget build(BuildContext context) {
    //final uuid;
    final displayName =
        TextEditingController(text: _credential?.getClearDisplayName());

    final password =
        TextEditingController(text: _credential?.getClearPassword());
    //final passwordSalt;

    final username =
        TextEditingController(text: _credential?.getClearUsername());
    //final usernameSalt;

    final websiteUrl =
        TextEditingController(text: _credential?.getClearWebsiteUrl());

    final note = TextEditingController(text: _credential?.getClearNote());

    void enableFields() {
      setState(() {
        _enabled = true;
        _obscurePassword = false;
      });
    }

    void disableFields() {
      if (_credential != null) {
        setState(() {
          _enabled = false;
          _obscurePassword = true;
        });
      } else {
        Navigator.of(context).pop();
      }
    }

    Future<bool> save() async {
      Credential temp;
      String? url = await ApiBaseData.getURL(); // Get Backend URL
      AuthenticationCredentialsSingleton authdata =
          await AuthService.getAuthenticationCredentials();
      try {
        if (url != null) {
          ApiClient apiClient =
              RequestUtility.getApiWithAuth(authdata.accessToken!.token!, url);
          CredentialsApi api = CredentialsApi(apiClient);
          if (_credential != null) {
            temp = await _credential!.updateFromLocal(
              masterPassword: authdata.encryptionKDF!,
              clearWebsiteUrl: websiteUrl.text,
              clearUsername: username.text,
              clearPassword: password.text,
              clearDisplayName: displayName.text,
              clearNote: note.text,
              folderUuid: newFolderUUID,
            );
            await api
                .credentialsUpdatePut(temp.updateAPICredentialRequestBody());
          } else {
            UUIDApi uuidApi = UUIDApi(apiClient);
            String? uuid = await ApiBaseData.apiCallWrapper(
                uuidApi.uuidNewGet(),
                logMessage: (context.mounted)
                    ? AppLocalizations.of(context)!.getUUIDTimeout
                    : null);
            temp = await Credential.newEntry(
              uuid: uuid!,
              masterPassword: authdata.encryptionKDF!,
              clearWebsiteUrl: websiteUrl.text,
              clearUsername: username.text,
              clearPassword: password.text,
              clearDisplayName: displayName.text,
              clearNote: note.text,
              folderUuid: newFolderUUID,
              createdTimeStamp: DateTime.now().microsecondsSinceEpoch ~/ 1000,
            );
            await ApiBaseData.apiCallWrapper(
                api.credentialsCreatePost(
                  CredentialsCreateRequestBody(
                    credential: temp.createAPICredential(),
                  ),
                ),
                logMessage: (context.mounted)
                    ? AppLocalizations.of(context)!.credentialCreateTimeout
                    : null);
          }
          setState(() {
            _credential = temp;
          });
          if (widget.onSaveCallback != null) widget.onSaveCallback!(temp);
          return true;
        } else {
          if (context.mounted) {
            NotificationPopup.apiError(context: context);
          }
        }
      } on ApiException catch (e) {
        if (context.mounted) {
          NotificationPopup.apiError(
              context: context, apiResponseMessage: e.message);
        }
      } on AnonKeyServerOffline catch (e) {
        if (context.mounted) {
          NotificationPopup.popupErrorMessage(
              context: context, message: e.message ?? "Timeout Error");
        }
      }
      return false;
    }

    Future<bool> delete() async {
      try {
        if (_credential != null) {
          String? url = await ApiBaseData.getURL(); // Get Backend URL
          AuthenticationCredentialsSingleton authdata =
              await AuthService.getAuthenticationCredentials();
          if (url != null) {
            ApiClient apiClient = RequestUtility.getApiWithAuth(
                authdata.accessToken!.token!, url);
            CredentialsApi api = CredentialsApi(apiClient);
            await ApiBaseData.apiCallWrapper(
                api.credentialsSoftDeletePut(_credential!.uuid),
                logMessage: (context.mounted)
                    ? AppLocalizations.of(context)!.credentialSoftDeleteTimeout
                    : null);
          }
          if (widget.onSoftDeleteCallback != null) {
            widget.onSoftDeleteCallback!(_credential!.uuid);
          }
          return true;
        } else {
          if (context.mounted) {
            NotificationPopup.apiError(context: context);
          }
        }
      } on ApiException catch (e) {
        if (context.mounted) {
          NotificationPopup.apiError(
              context: context, apiResponseMessage: e.message);
        }
      } on AnonKeyServerOffline catch (e) {
        if (context.mounted) {
          NotificationPopup.popupErrorMessage(
              context: context, message: e.message ?? "Timeout Error");
        }
      }
      return false;
    }

    /// Popup to confirm deletion
    showDeleteConfirmDialog(Credential credential) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // Retrieve the text the that user has entered by using the
            // TextEditingController.
            title: Text(AppLocalizations.of(context)!
                .confirmCredentialSoftDeleteTitle(
                    credential.getClearDisplayName())),
            //content: Text('Are you sure you want to move Credential "${credential.getClearDisplayName()}" into the deleted Folder?'),
            content: Text(AppLocalizations.of(context)!
                .confirmCredentialSoftDeleteText(
                    credential.getClearDisplayName())),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white),
                      child: Text(AppLocalizations.of(context)!.abort),
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
                            if (value && context.mounted) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                          },
                        );
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white),
                      child: Text(AppLocalizations.of(context)!.confirm),
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
        title: Text(_credential?.getClearDisplayName() ?? ""),
        actions: [
          if (!_enabled)
            IconButton(
              onPressed: () => ApiBaseData.callFuncIfServerReachable(
                enableFields,
                context: context,
              ),
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          if (_enabled)
            IconButton(
                onPressed: () => {
                      save().then(
                        (value) {
                          if (value) {
                            disableFields();
                          }
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
      floatingActionButton: (_credential != null)
          ? FloatingActionButton(
              onPressed: () => ApiBaseData.callFuncIfServerReachable(
                () => showDeleteConfirmDialog(_credential!),
                context: context,
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          children: [
            EntryInput(
              key: UniqueKey(),
              controller: displayName,
              label: AppLocalizations.of(context)!.displayName,
              obscureText: false,
              focus: displayNameFocus,
              enabled: _enabled,
            ),
            SizedBox(height: spacing),
            EntryInput(
              key: UniqueKey(),
              controller: websiteUrl,
              label: AppLocalizations.of(context)!.url,
              obscureText: false,
              focus: websiteUrlFocus,
              enabled: _enabled,
            ),
            SizedBox(height: spacing),
            EntryInput(
              key: UniqueKey(),
              controller: username,
              label: AppLocalizations.of(context)!.username,
              obscureText: false,
              focus: usernameFocus,
              enabled: _enabled,
            ),
            SizedBox(height: spacing),
            EntryInput(
              key: UniqueKey(),
              controller: password,
              label: AppLocalizations.of(context)!.password,
              obscureText: _obscurePassword,
              focus: passwordFocus,
              enabled: _enabled,
            ),
            SizedBox(height: spacing),
            //TODO: update Notes to multi-line Text Area
            EntryInput(
              key: UniqueKey(),
              controller: note,
              label: AppLocalizations.of(context)!.notes,
              obscureText: false,
              focus: noteFocus,
              enabled: _enabled,
            ),
            SizedBox(height: spacing),
            FolderDropdown(
              key: UniqueKey(),
              folders: widget.availableFolders,
              enabled: _enabled,
              currentFolderUuid: (_credential == null)
                  ? (widget.currentFolderUuid ?? "")
                  : (_credential?.folderUuid ?? ""),
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
