import 'dart:async';

import 'package:anonkey_frontend/Utility/api_base_data.dart';
import 'package:anonkey_frontend/Utility/notification_popup.dart';
import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:anonkey_frontend/src/Widgets/entry_input.dart';
import 'package:anonkey_frontend/src/Widgets/icon_picker.dart';
import 'package:anonkey_frontend/src/exception/auth_exception.dart';
import 'package:anonkey_frontend/src/exception/missing_build_context_exception.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';

class FolderEditWidget extends StatefulWidget {
  final Folder? folder;
  final Function({required Folder folderData})? onSaveCallback;
  final Function({required String uuid, required bool recursive})?
  onDeleteCallback;
  final Function()? onAbortCallback;

  const FolderEditWidget({
    super.key,
    this.folder,
    this.onSaveCallback,
    this.onAbortCallback,
    this.onDeleteCallback,
  });

  @override
  State<StatefulWidget> createState() => _FolderEditWidget();
}

class _FolderEditWidget extends State<FolderEditWidget> {
  final displayNameFocus = FocusNode();
  late bool _enabled;
  late Folder? _folder;
  final double spacing = 16.0;
  final _formkey = GlobalKey<FormState>();

  IconData? _iconData;

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _enabled = (widget.folder == null);
    _folder = widget.folder;
    _iconData = _folder?.getIconData() ?? Icons.folder;
  }

  void updateIcon({required IconData? iconData}) {
    _iconData = iconData;
  }

  @override
  Widget build(BuildContext context) {
    //final uuid;
    final displayName = TextEditingController(text: _folder?.displayName);

    void enableFields() {
      setState(() {
        _enabled = true;
      });
    }

    void disableFields() {
      if (_folder != null) {
        setState(() {
          _enabled = false;
          _iconData = _folder!.getIconData();
        });
      } else {
        Navigator.of(context).pop();
      }
    }

    Future<bool> save() async {
      String? url = await ApiBaseData.getURL(); // Get Backend URL
      AuthenticationCredentialsSingleton authdata =
          await AuthService.getAuthenticationCredentials();
      try {
        if (url != null && authdata.accessToken != null) {
          ApiClient apiClient = RequestUtility.getApiWithAuth(
            authdata.accessToken!.token,
            url,
          );
          FoldersApi api = FoldersApi(apiClient);
          if (_folder != null) {
            Folder temp = Folder(
              displayName: displayName.text,
              iconData: _iconData?.codePoint ?? _folder!.getIconCodePoint(),
              uuid: _folder!.uuid,
            );
            await ApiBaseData.apiCallWrapper(
              api.foldersUpdatePut(temp.updateFolderBody()),
              logMessage:
                  (context.mounted)
                      ? AppLocalizations.of(context)!.folderUpdateTimeout
                      : null,
            );
            setState(() {
              _folder = temp;
            });
          } else {
            FoldersCreateResponseBody? response =
                await ApiBaseData.apiCallWrapper(
                  api.foldersCreatePost(
                    FoldersCreateRequestBody(
                      folder: FoldersCreateFolder(
                        icon: _iconData!.codePoint,
                        name: displayName.text,
                      ),
                    ),
                  ),
                  logMessage:
                      (context.mounted)
                          ? AppLocalizations.of(context)!.folderCreateTimeout
                          : null,
                );
            _folder = Folder(
              displayName: displayName.text,
              iconData: _iconData!.codePoint,
              uuid: response!.folderUuid,
            );
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
            context: context,
            apiResponseMessage: e.message,
          );
        }
      } on AnonKeyServerOffline catch (e) {
        if (context.mounted) {
          NotificationPopup.popupErrorMessage(
            context: context,
            message: e.message ?? "Timeout Error",
          );
        }
      } on AuthException catch (_) {
        await AuthService.deleteAuthenticationCredentials();
        if (context.mounted) {
          context.push("/login");
          return false;
        } else {
          throw MissingBuildContextException();
        }
      }
      return false;
    }

    Future<bool> delete(bool recursive) async {
      String? url = await ApiBaseData.getURL(); // Get Backend URL
      AuthenticationCredentialsSingleton authdata =
          await AuthService.getAuthenticationCredentials();
      try {
        if (url != null && authdata.accessToken != null) {
          ApiClient apiClient = RequestUtility.getApiWithAuth(
            authdata.accessToken!.token,
            url,
          );
          FoldersApi api = FoldersApi(apiClient);
          await ApiBaseData.apiCallWrapper(
            api.foldersDeleteDelete(_folder!.uuid!, recursive),
            logMessage:
                (context.mounted)
                    ? AppLocalizations.of(context)!.folderDeleteTimeout
                    : null,
          );
        } else {
          if (context.mounted) {
            NotificationPopup.apiError(context: context);
          }
          return false;
        }
        if (widget.onDeleteCallback != null) {
          widget.onDeleteCallback!(uuid: _folder!.uuid!, recursive: recursive);
        }
      } on ApiException catch (e) {
        if (context.mounted) {
          NotificationPopup.apiError(
            context: context,
            apiResponseMessage: e.message,
          );
        }
        return false;
      } on AnonKeyServerOffline catch (e) {
        if (context.mounted) {
          NotificationPopup.popupErrorMessage(
            // ignore: use_build_context_synchronously
            context: context,
            message: e.message ?? "Timeout Error",
          );
          return false;
        }
      } on AuthException catch (_) {
        await AuthService.deleteAuthenticationCredentials();
        if (context.mounted) {
          context.push("/login");
          return false;
        } else {
          throw MissingBuildContextException();
        }
      }
      return true;
    }

    showDeleteConfirmDialog(Folder folder) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // Retrieve the text the that user has entered by using the
            // TextEditingController.
            title: Text(
              AppLocalizations.of(
                context,
              )!.confirmFolderDeleteTitle(folder.displayName),
            ),
            //content: Text('Are you sure you want to move Credential "${credential.getClearDisplayName()}" into the deleted Folder?'),
            content: Text(
              AppLocalizations.of(
                context,
              )!.confirmFolderDeleteText(folder.displayName),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
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
                        foregroundColor: Colors.white,
                      ),
                      child: Text(AppLocalizations.of(context)!.abort),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        delete(true).then((value) {
                          if (value) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        AppLocalizations.of(
                          context,
                        )!.deleteFolderWithCredentials,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        delete(false).then((value) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        AppLocalizations.of(
                          context,
                        )!.deleteFolderKeepCredentials,
                      ),
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
        title: Text(_folder?.displayName ?? ""),
        actions: [
          if (!_enabled)
            IconButton(
              onPressed: () => enableFields(),
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          if (_enabled)
            IconButton(
              onPressed:
                  () => {
                    if (_formkey.currentState!.validate())
                      {
                        save().then((value) {
                          if (value) {
                            disableFields();
                            if (widget.onSaveCallback != null &&
                                _folder != null)
                              widget.onSaveCallback!(folderData: _folder!);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          }
                        }),
                      },
                  },
              icon: Icon(
                Icons.save,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          if (_enabled)
            IconButton(
              onPressed:
                  () => {
                    disableFields(),
                    if (widget.onAbortCallback != null)
                      widget.onAbortCallback!(),
                  },
              icon: Icon(
                Icons.cancel,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          const SizedBox(width: 8.0),
        ],
      ),
      floatingActionButton:
          (_folder != null)
              ? FloatingActionButton(
                onPressed: () => showDeleteConfirmDialog(_folder!),
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
              : null,
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              EntryInput(
                key: UniqueKey(),
                controller: displayName,
                label: AppLocalizations.of(context)!.displayName,
                focus: displayNameFocus,
                validator: ValidationBuilder().required().build(),
                obscureText: false,
                enabled: _enabled,
              ),
              SizedBox(height: spacing),
              IconPicker(
                key: UniqueKey(),
                iconData: _iconData,
                enabled: _enabled,
                iconCallback: updateIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
