import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:flutter/material.dart';

class DropdownTile {
  static DropdownMenuItem<String> withIcon(
      {required String value,
      required String displayText,
      required IconData icondata,
      Color? fontColor}) {
    return DropdownMenuItem(
      value: value,
      child: Row(children: [
        Icon(
          icondata,
          color: fontColor,
          size: 20.0,
        ),
        const Padding(padding: EdgeInsets.only(right: 10)),
        Text(
          displayText,
          style: TextStyle(
            color: fontColor,
          ),
        ),
      ]),
    );
  }

  static DropdownMenuItem<String> normal(
      {required String value, required String displayText, Color? fontColor}) {
    return DropdownMenuItem(
      value: value,
      child: Row(children: [
        Text(
          displayText,
          style: TextStyle(
            color: fontColor,
          ),
        ),
      ]),
    );
  }

  static DropdownMenuItem<String> fromFolder(
      {required Folder folder, Color? fontColor}) {
    return withIcon(
        value: folder.uuid!,
        displayText: folder.displayName,
        icondata: folder.getIconData(),
        fontColor: fontColor);
  }
}
