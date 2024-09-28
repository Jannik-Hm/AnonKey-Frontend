import 'package:flutter/material.dart';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:anonkey_frontend/src/Credentials/list-entry/credential_input.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart' as iconpicker;
import 'package:flutter_iconpicker/Models/configuration.dart';

class FolderEditWidget extends StatefulWidget {
  final Folder? folder;
  final void Function({required int codePoint})? iconCallback;

  const FolderEditWidget({
    super.key,
    this.folder,
    this.iconCallback,
  });

  @override
  State<StatefulWidget> createState() => _FolderEditWidget();
}

class _FolderEditWidget extends State<FolderEditWidget> {
  final displayNameFocus = FocusNode();
  late bool _enabled;
  late Folder _folder;
  final double spacing = 16.0;

  IconData? _iconData;

  _pickIcon() async {
    iconpicker.IconPickerIcon? icon = await iconpicker.showIconPicker(
      context,
      configuration: SinglePickerConfiguration(
        iconPackModes: [iconpicker.IconPack.material],
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconColor: Theme.of(context).colorScheme.onSurface,
      ),
    );
    _iconData = icon?.data;
    setState(() {});

    debugPrint('Picked Icon:  $icon');
  }

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _enabled = false;
    _folder = widget.folder ?? Folder(iconData: 0, displayName: "", uuid: "");
    if (widget.folder != null) {
      _iconData = widget.folder?.getIconData();
    }
  }

  @override
  Widget build(BuildContext context) {
    //final uuid;
    final displayName = TextEditingController(text: _folder.displayName);

    void enableFields() {
      setState(() {
        _enabled = true;
      });
    }

    void disableFields() {
      setState(() {
        _enabled = false;
        _iconData = _folder.getIconData();
      });
    }

    void save() {
      _folder.displayName = displayName.text;
      if (_iconData != null) {
        widget.iconCallback!(codePoint: _iconData!.codePoint);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(_folder.displayName),
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
          const SizedBox(
            width: 8.0,
          ),
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
            if (_enabled) TextButton(onPressed: _pickIcon, child: const Text("Icon auswählen")),
            const SizedBox(height: 10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: (_iconData != null)
                  ? Icon(
                      _iconData,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 100.0,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
