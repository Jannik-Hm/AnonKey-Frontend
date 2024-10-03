import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:anonkey_frontend/src/Widgets/entry_input.dart';
import 'package:anonkey_frontend/src/Widgets/icon_picker.dart';
import 'package:form_validator/form_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FolderEditWidget extends StatefulWidget {
  final Folder? folder;
  final void Function({required int codePoint})? iconCallback;
  final Function({required Folder folderData})? onSaveCallback;
  final Function()? onAbortCallback;

  const FolderEditWidget({
    super.key,
    this.folder,
    this.iconCallback,
    this.onSaveCallback,
    this.onAbortCallback,
  });

  @override
  State<StatefulWidget> createState() => _FolderEditWidget();
}

class _FolderEditWidget extends State<FolderEditWidget> {
  final displayNameFocus = FocusNode();
  late bool _enabled;
  late Folder _folder;
  final double spacing = 16.0;
  final _formkey = GlobalKey<FormState>();

  IconData? _iconData;

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _enabled = (widget.folder == null);
    _folder = widget.folder ?? Folder(iconData: Icons.folder.codePoint, displayName: "", uuid: "");
    _iconData = _folder.getIconData();
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

    void save() async {
      _folder.displayName = displayName.text;
      if (_iconData != null) {
        _folder.setIcon(codePoint: _iconData!.codePoint);
        if(widget.folder != null && widget.iconCallback != null){
          widget.iconCallback!(codePoint: _iconData!.codePoint);
        }
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? url = prefs.getString('url');
      Map<String, String> authdata = await AuthService.getAuthenticationCredentials();
      if (url != null) {
        ApiClient apiClient = RequestUtility.getApiWithAuth(authdata["token"]!, url);
        FoldersApi api = FoldersApi(apiClient);
        await api.foldersUpdatePut(_folder.updateFolderBody());
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
                onPressed: () => {
                      if (_formkey.currentState!.validate())
                        {
                          save(),
                          disableFields(),
                          if (widget.onSaveCallback != null) widget.onSaveCallback!(folderData: _folder),
                        },
                    },
                icon: Icon(
                  Icons.save,
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
          if (_enabled)
            IconButton(
                onPressed: () => {
                      disableFields(),
                      if (widget.onAbortCallback != null) widget.onAbortCallback!(),
                    },
                icon: Icon(
                  Icons.cancel,
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
          const SizedBox(
            width: 8.0,
          ),
        ],
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              EntryInput(
                key: UniqueKey(),
                controller: displayName,
                label: 'Display Name',
                focus: displayNameFocus,
                validator: ValidationBuilder().required().build(),
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
      ),
    );
  }
}
