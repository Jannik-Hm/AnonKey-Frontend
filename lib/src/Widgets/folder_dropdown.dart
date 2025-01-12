import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:anonkey_frontend/src/Widgets/dropdown_button.dart';
import 'package:anonkey_frontend/src/Widgets/dropdown_tile.dart';
import 'package:flutter/material.dart';

class FolderDropdown extends StatefulWidget {
  final bool enabled;
  final List<Folder> folders;
  final Function(String? value)? onChangeCallback;
  final String currentFolderUuid;

  const FolderDropdown(
      {super.key,
      this.enabled = true,
      required this.folders,
      this.onChangeCallback,
      this.currentFolderUuid = ""});

  @override
  State<StatefulWidget> createState() => _FolderDropdown();
}

class _FolderDropdown extends State<FolderDropdown> {
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _enabled = widget.enabled;
  }

  List<DropdownMenuItem<String>>? getItems() {
    List<DropdownMenuItem<String>>? items = [];
    items.add(DropdownTile.normal(value: "", displayText: ""));
    for (var element in widget.folders) {
      items.add(DropdownTile.fromFolder(
          folder: element,
          fontColor: Theme.of(context).colorScheme.onSecondary));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return DropDownButton(
      enabled: _enabled,
      preselectedValue: widget.currentFolderUuid,
      items: getItems(),
      onChangeCallback: widget.onChangeCallback,
    );
  }
}
