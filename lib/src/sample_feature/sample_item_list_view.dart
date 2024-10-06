import 'package:anonkey_frontend/src/Credentials/credential_list.dart';
import 'package:anonkey_frontend/src/Credentials/credential_list_view.dart';
import 'package:anonkey_frontend/src/Folders/folder_list.dart';
import 'package:anonkey_frontend/src/Folders/folder_list_view_widget.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'sample_item.dart';

class _CombinedData {
  final CredentialList? credentials;
  final FolderList? folders;

  _CombinedData({required this.credentials, required this.folders});
}

/// Displays a list of SampleItems.
class SampleItemListView extends StatelessWidget {
  const SampleItemListView({
    super.key,
    this.items = const [SampleItem(1), SampleItem(2), SampleItem(3)],
  });

  static const routeName = '/';

  final List<SampleItem> items;

  @override
  Widget build(BuildContext context) {
    void _logout() async {
      await AuthService.deleteAuthenticationCredentials();
      if (!context.mounted) return;
      context.replaceNamed("login");
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              context.pushNamed("settings");
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      /* body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
              title: Text('SampleItem ${item.id}'),
              leading: const CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              onTap: () {
                // Navigate to the details page. If the user leaves and returns to
                // the app after it has been killed while running in the
                // background, the navigation stack is restored.
                context.pushNamed("items");
              });
        },
      ), */
      body: Column(
          children: [
            Expanded(
              child: FutureBuilder<_CombinedData>(
                future: Future.wait([CredentialList.getFromAPIFull(), FolderList.getFromAPIFull()]).then(
                  (results) {
                    return _CombinedData(credentials: results[0] as CredentialList, folders: results[1] as FolderList);
                  },
                ),
                builder: (context, snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                    children = <Widget>[
                      CredentialListWidget(
                        credentials: snapshot.data!.credentials!,
                        availableFolders: snapshot.data!.folders,
                        currentFolderUuid: "",
                      ),
                      FolderListWidget(folders: snapshot.data!.folders!, credentials: snapshot.data!.credentials!,),
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
            ),
            TextButton(
              onPressed: () => _logout(),
              child: const Text("Logout"),
            ),
          ],
        ),
    );
  }
}
