import 'package:flutter/material.dart';
import 'package:anonkey_frontend/src/Credentials/list-entry/credential_input.dart';
import 'package:anonkey_frontend/src/Credentials/credential_data.dart';

class CredentialDetailWidget extends StatefulWidget {
  final Credential credential;

  const CredentialDetailWidget({
    super.key,
    required this.credential,
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

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _enabled = false;
    _obscurePassword = true;
    _credential = widget.credential;
  }

  @override
  Widget build(BuildContext context) {
    //final uuid;
    final displayName = TextEditingController(text: _credential.displayName);

    final password = TextEditingController(text: _credential.clearPassword);
    //final passwordSalt;

    final username = TextEditingController(text: _credential.username);
    //final usernameSalt;

    final websiteUrl = TextEditingController(text: _credential.websiteUrl);

    final note = TextEditingController(text: _credential.note);
    // String folderUuid;

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

    void save() {
      _credential.displayName = displayName.text;
      _credential.username = username.text;
      _credential.clearPassword = password.text;
      _credential.websiteUrl = websiteUrl.text;
      _credential.note = note.text;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(_credential.displayName),
        actions: [
          if (!_enabled) IconButton(onPressed: () => enableFields(), icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.onPrimary)),
          if (_enabled)
            IconButton(
                onPressed: () => {save(), disableFields()},
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
          const SizedBox(width: 8.0,),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          children: [
            CredentialInput(
              key: UniqueKey(),
              controller: displayName,
              label: 'Display Name',
              obscureText: false,
              focus: displayNameFocus,
              enabled: _enabled,
            ),
            SizedBox(height: spacing),
            CredentialInput(
              key: UniqueKey(),
              controller: websiteUrl,
              label: 'URL',
              obscureText: false,
              focus: websiteUrlFocus,
              enabled: _enabled,
            ),
            SizedBox(height: spacing),
            CredentialInput(
              key: UniqueKey(),
              controller: username,
              label: 'Username',
              obscureText: false,
              focus: usernameFocus,
              enabled: _enabled,
            ),
            SizedBox(height: spacing),
            CredentialInput(
              key: UniqueKey(),
              controller: password,
              label: 'Password',
              obscureText: _obscurePassword,
              focus: passwordFocus,
              enabled: _enabled,
            ),
            SizedBox(height: spacing),
            CredentialInput(
              key: UniqueKey(),
              controller: note,
              label: 'Notes',
              obscureText: false,
              focus: noteFocus,
              enabled: _enabled,
            ),
          ],
        ),
      ),
    );
  }
}
