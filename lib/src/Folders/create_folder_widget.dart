import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:anonkey_frontend/src/Folders/list-entry/folder_edit.dart';
import 'package:flutter/material.dart';

class CreateFolderWidget extends StatefulWidget {
  final Function(Folder) addFolderToList;

  /// [addFolderToList] must contain `setState(() {folderList.add(folder);});`
  const CreateFolderWidget({
    super.key,
    required this.addFolderToList,
  });

  @override
  State<StatefulWidget> createState() => _CreateFolderWidget();
}

class _CreateFolderWidget extends State<CreateFolderWidget> {
  bool created = false;

  Future<void> onSaveCallback({required Folder folderData}) async {
    if (!created) {
      widget.addFolderToList(folderData);
      created = true;
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FolderEditWidget(
              folder: null,
              onSaveCallback: onSaveCallback,
            ),
          ),
        )
      },
      icon: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}