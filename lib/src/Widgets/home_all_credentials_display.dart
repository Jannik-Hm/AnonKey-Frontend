import 'package:anonkey_frontend/Utility/combined_future_data.dart';
import 'package:anonkey_frontend/src/Credentials/create_credential_widget.dart';
import 'package:anonkey_frontend/src/Credentials/credential_data.dart';
import 'package:anonkey_frontend/src/Credentials/credential_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeCredentialsDisplayWidget extends StatefulWidget {
  final CombinedListData combinedData;

  const HomeCredentialsDisplayWidget({super.key, required this.combinedData});

  @override
  State<StatefulWidget> createState() => _HomeCredentialsDisplayWidget();
}

class _HomeCredentialsDisplayWidget
    extends State<HomeCredentialsDisplayWidget> {
  late CombinedListData _combinedData;

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _combinedData = widget.combinedData;
    /* _enabled = widget.enabled;
    selectedValue = widget.preselectedValue; */
  }

  void addToCredentials(Credential credential) {
    setState(() {
      _combinedData.credentials!.add(credential);
      _combinedData.credentials!.saveToDisk();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.passwordsMenu,
              style: theme.textTheme.headlineMedium,
            ),
            CreateCredentialWidget(
              availableFolders:
                  _combinedData.folders?.byIDList.values.toList() ?? [],
              credentials: _combinedData.credentials!,
              addToCredentials: addToCredentials,
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          child: CredentialListWidget(
            key: UniqueKey(),
            availableFolders: _combinedData.folders,
            credentials: _combinedData.credentials!,
            currentFolderUuid: null,
          ),
        ),
      ],
    );
  }
}
