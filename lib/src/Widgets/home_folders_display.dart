import 'package:anonkey_frontend/Utility/combined_future_data.dart';
import 'package:anonkey_frontend/src/Folders/create_folder_widget.dart';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:anonkey_frontend/src/Folders/folder_list_view_widget.dart';
import 'package:flutter/material.dart';

class HomeFoldersDisplayWidget extends StatefulWidget {
  final CombinedListData combinedData;

  const HomeFoldersDisplayWidget({
    super.key,
    required this.combinedData,
  });

  @override
  State<StatefulWidget> createState() => _HomeFoldersDisplayWidget();
}

class _HomeFoldersDisplayWidget extends State<HomeFoldersDisplayWidget> {
  late CombinedListData _combinedData;

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _combinedData = widget.combinedData;
    /* _enabled = widget.enabled;
    selectedValue = widget.preselectedValue; */
  }

  void addFolderToList(Folder folder) {
    setState(() {_combinedData.folders!.add(folder);});
  }

  // TODO: fix Update while staying in create folder view or do Navigation.pop?

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Folders',
              style: theme.textTheme.headlineSmall,
            ),
            CreateFolderWidget(addFolderToList: addFolderToList),
          ],
        ),
        const SizedBox(height: 10),
        FolderListWidget(
          key: UniqueKey(),
          folders: _combinedData.folders!,
          credentials: _combinedData.credentials!,
        ),
      ],
    );
  }
}