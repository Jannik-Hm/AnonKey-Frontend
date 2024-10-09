import 'package:anonkey_frontend/src/Credentials/credential_data.dart';
import 'package:anonkey_frontend/src/Credentials/credential_list.dart';
import 'package:anonkey_frontend/src/Credentials/trash-can/credential_entry.dart';
import 'package:flutter/material.dart';

class CredentialTrashListWidget extends StatefulWidget {
  final CredentialList credentials;

  const CredentialTrashListWidget({
    super.key,
    required this.credentials,
  });

  @override
  State<StatefulWidget> createState() => _CredentialTrashListWidget();
}

class _CredentialTrashListWidget extends State<CredentialTrashListWidget> {
  final double spacing = 16.0;

  late CredentialList credentials;

  late List<Credential> credentialList;

  CredentialTrashEntry _fromList(Credential credential) {
    return CredentialTrashEntry(
      key: UniqueKey(),
      credential: credential,
    );
  }

  @override
  void initState() {
    super.initState();
    credentials = widget.credentials;
    credentialList = credentials.deletedList.values.toList();
    // Initialize the mutable object from the widget field
  }

  @override
  Widget build(BuildContext context) {
    credentialList.sort((x, y) => x.getClearDisplayName().compareTo(y.getClearDisplayName()));
    return Column(children: credentialList.map(_fromList).toList());
  }
}
