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
  final passwordFocus = FocusNode();
  final usernameFocus = FocusNode();
  final websiteUrlFocus = FocusNode();
  final noteFocus = FocusNode();
  late bool _enabled;
  late bool _obscurePassword;
  final double spacing = 16.0;

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _enabled = false;
    _obscurePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    //final uuid;
    final displayName = TextEditingController(text: widget.credential.displayName);

    final password = TextEditingController(text: widget.credential.clearPassword);
    //final passwordSalt;

    final username = TextEditingController(text: widget.credential.username);
    //final usernameSalt;

    final websiteUrl = TextEditingController(text: widget.credential.websiteUrl);

    final note = TextEditingController(text: widget.credential.note);
    // String folderUuid;

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
      widget.credential.username = username.text;
      widget.credential.clearPassword = password.text;
      widget.credential.websiteUrl = websiteUrl.text;
      widget.credential.note = note.text;
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
