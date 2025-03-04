import 'package:anonkey_frontend/Utility/api_base_data.dart';
import 'package:anonkey_frontend/Utility/notification_popup.dart';
import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/Credentials/credential_data.dart';
import 'package:anonkey_frontend/src/Credentials/list-entry/logo.dart';
import 'package:anonkey_frontend/src/Widgets/clickable_tile.dart';
import 'package:anonkey_frontend/src/exception/auth_exception.dart';
import 'package:anonkey_frontend/src/exception/missing_build_context_exception.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

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

  Future<bool> restore() async {
    String? url = await ApiBaseData.getURL(); // Get Backend URL
    AuthenticationCredentialsSingleton authdata =
        await AuthService.getAuthenticationCredentials();
    try {
      if (url != null && authdata.accessToken != null) {
        ApiClient apiClient = RequestUtility.getApiWithAuth(
          authdata.accessToken!.token,
          url,
        );
        CredentialsApi api = CredentialsApi(apiClient);
        await ApiBaseData.apiCallWrapper(
          api.credentialsSoftUndeletePut(_credential.uuid),
          logMessage:
              (mounted)
                  ? AppLocalizations.of(context)!.credentialRestoreTimeout
                  : null,
        );
        return true;
      } else {
        if (mounted) {
          NotificationPopup.apiError(context: context);
        }
      }
    } on ApiException catch (e) {
      if (mounted) {
        NotificationPopup.apiError(
          context: context,
          apiResponseMessage: e.message,
        );
      }
    } on AnonKeyServerOffline catch (e) {
      if (mounted) {
        NotificationPopup.popupErrorMessage(
          context: context,
          message: e.message ?? "Timeout Error",
        );
      }
    } on AuthException catch (_) {
      await AuthService.deleteAuthenticationCredentials();
      if (mounted) {
        context.push("/login");
        return false;
      } else {
        throw MissingBuildContextException();
      }
    }
    return false;
  }

  Future<bool> deleteForever() async {
    String? url = await ApiBaseData.getURL(); // Get Backend URL
    AuthenticationCredentialsSingleton authdata =
        await AuthService.getAuthenticationCredentials();
    try {
      if (url != null && authdata.accessToken != null) {
        ApiClient apiClient = RequestUtility.getApiWithAuth(
          authdata.accessToken!.token,
          url,
        );
        CredentialsApi api = CredentialsApi(apiClient);
        await ApiBaseData.apiCallWrapper(
          api.credentialsDeleteDelete(_credential.uuid),
          logMessage:
              (mounted)
                  ? AppLocalizations.of(context)!.credentialFinalDeleteTimeout
                  : null,
        );
        return true;
      } else {
        if (mounted) {
          NotificationPopup.apiError(context: context);
        }
      }
    } on ApiException catch (e) {
      if (mounted) {
        NotificationPopup.apiError(
          context: context,
          apiResponseMessage: e.message,
        );
      }
    } on AnonKeyServerOffline catch (e) {
      if (mounted) {
        NotificationPopup.popupErrorMessage(
          context: context,
          message: e.message ?? "Timeout Error",
        );
      }
    } on AuthException catch (_) {
      await AuthService.deleteAuthenticationCredentials();
      if (mounted) {
        context.push("/login");
        return false;
      } else {
        throw MissingBuildContextException();
      }
    }
    return false;
  }

  /// show Popup to delete forever or restore Credential
  showDeleteConfirmDialog(Credential credential) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Retrieve the text the that user has entered by using the
          // TextEditingController.
          title: Text(
            AppLocalizations.of(
              context,
            )!.confirmCredentialDeleteTitle(credential.getClearDisplayName()),
          ),
          //content: Text('Are you sure you want to move Credential "${credential.getClearDisplayName()}" into the deleted Folder?'),
          content: Text(
            AppLocalizations.of(
              context,
            )!.confirmCredentialDeleteText(credential.getClearDisplayName()),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      restore().then((value) {
                        if (value) {
                          widget.onRestoreCallback(_credential);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(AppLocalizations.of(context)!.restore),
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      deleteForever().then((value) {
                        if (value) {
                          widget.onDeleteForeverCallback(_credential);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(AppLocalizations.of(context)!.deleteForever),
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
      onTap:
          () => ApiBaseData.callFuncIfServerReachable(() {
            showDeleteConfirmDialog(_credential);
          }, context: context),
      leading: SizedBox(
        width: 40.0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 40.0, maxHeight: 40.0),
          child: getNetworkLogoFromUrl(_credential.getClearWebsiteUrl()),
        ),
      ),
      title: Text(
        _credential.getClearDisplayName(),
        style: TextStyle(fontSize: 20.0, color: theme.colorScheme.onTertiary),
      ),
      subTitle: Text(
        _credential.getClearUsername(),
        style: TextStyle(fontSize: 15.0, color: theme.colorScheme.onTertiary),
      ),
    );
  }
}
