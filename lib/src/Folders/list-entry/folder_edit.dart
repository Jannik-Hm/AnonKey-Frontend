import 'package:flutter/material.dart';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:anonkey_frontend/src/Widgets/entry_input.dart';
import 'package:anonkey_frontend/src/Widgets/icon_picker.dart';

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

  void updateIcon({required IconData? iconData}) {
    _iconData = iconData;
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
            EntryInput(
              key: UniqueKey(),
              controller: displayName,
              label: 'Display Name',
              focus: displayNameFocus,
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
    );
  }
}
