import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:anonkey_frontend/src/Credentials/list-entry/credential_input.dart';
import 'package:anonkey_frontend/src/Credentials/credential_data.dart';

class CredentialDetailWidget extends StatefulWidget {
  Credential credential;

  CredentialDetailWidget({
    super.key,
    required this.credential,
  });

  @override
  State<StatefulWidget> createState() => _CredentialDetailWidget();
}

class _CredentialDetailWidget extends State<CredentialDetailWidget> {
  final displayNameFocus = FocusNode();
  late bool _enabled;
  late bool _obscurePassword;

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _enabled = false;
    _obscurePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    final displayName = TextEditingController(text: widget.credential.displayName);
    final GlobalKey<CredentialInputState> displayNameWidget = GlobalKey<CredentialInputState>();

    void _enableFields() {
      setState(() {
        _enabled = true;
        _obscurePassword = false;
      });
    }

    void _disableFields() {
      setState(() {
        _enabled = false;
        _obscurePassword = true;
      });
    }

    void _save() {
      widget.credential.displayName = displayName.text;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(widget.credential.displayName),
        actions: [
          if (!_enabled) IconButton(onPressed: () => _enableFields(), icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.onPrimary)),
          if (_enabled)
            IconButton(
                onPressed: () => {_save(), _disableFields()},
                icon: Icon(
                  Icons.save,
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
          if (_enabled)
            IconButton(
                onPressed: () => _disableFields(),
                icon: Icon(
                  Icons.cancel,
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
          //IconButton(onPressed: () => displayNameWidget.currentState?.enable(), icon: Icon(Icons.edit))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          children: [
            CredentialInput(
              key: displayNameWidget,
              controller: displayName,
              label: 'Display Name',
              obscureText: _obscurePassword,
              focus: displayNameFocus,
              enabled: _enabled,
              //value: widget.credential.displayName,
            ),
          ],
        ),
      ),
    );
  }
}
