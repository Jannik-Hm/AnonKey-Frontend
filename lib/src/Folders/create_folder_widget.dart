import 'package:anonkey_frontend/Utility/api_base_data.dart';
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
  Future<void> onSaveCallback({required Folder folderData}) async {
    widget.addFolderToList(folderData);
  }

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => ApiBaseData.callFuncIfServerReachable(
          () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FolderEditWidget(
                    folder: null,
                    onSaveCallback: onSaveCallback,
                  ),
                ),
              ),
          context: context),
      icon: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
