import 'package:anonkey_frontend/Utility/combined_future_data.dart';
import 'package:anonkey_frontend/src/Folders/create_folder_widget.dart';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:anonkey_frontend/src/Folders/folder_list_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeFoldersDisplayWidget extends StatefulWidget {
  final CombinedListData combinedData;
  final Function(bool recursive) onDeleteCallback;

  const HomeFoldersDisplayWidget({
    super.key,
    required this.combinedData,
    required this.onDeleteCallback,
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
              AppLocalizations.of(context)!.folders,
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
          onDeleteCallback: widget.onDeleteCallback,
        ),
      ],
    );
  }
}
