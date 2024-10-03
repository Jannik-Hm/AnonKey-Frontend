import 'package:anonkey_frontend/src/Credentials/credential_list.dart';
import 'package:anonkey_frontend/src/Credentials/list-entry/credential_entry.dart';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:anonkey_frontend/src/Folders/folder_list.dart';
import 'package:flutter/material.dart';

class CredentialListWidget extends StatefulWidget {
  final Future<CredentialList?> credentials;
  final Future<FolderList?> availableFolders;

  const CredentialListWidget({
    super.key,
    required this.credentials,
    required this.availableFolders,
  });

  @override
  State<StatefulWidget> createState() => _CredentialListWidget();
}

class _combinedData {
  final CredentialList? credentials;
  final FolderList? folders;

  _combinedData({required this.credentials, required this.folders});
}

class _CredentialListWidget extends State<CredentialListWidget> {
  final double spacing = 16.0;

  late Future<CredentialList?> credentials;

  @override
  void initState() {
    super.initState();
    credentials = widget.credentials;
    // Initialize the mutable object from the widget field
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<_combinedData>(
        future: Future.wait(
          [credentials, widget.availableFolders]
        ).then((results) {
          return _combinedData(credentials: results[0] as CredentialList, folders: results[1] as FolderList);
        },),
        //future: credentials,
        builder: (context, snapshot) {
          List<Widget> children;
          print(snapshot.data?.credentials?.byIDList);
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            children = <Widget>[
              CredentialEntry(
                credential: snapshot.data!.credentials!.byIDList["ebd1ef35-cade-4e2a-8117-3ed58bd13143"]!,
                onSaveCallback: (credential) {
                  setState(() {
                    credentials = snapshot.data!.credentials!.updateFromLocalObject(credential: credential);
                  });
                },
                availableFolders: snapshot.data!.folders!.toList(),
              ),
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
