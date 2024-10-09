import 'package:anonkey_frontend/Utility/combined_future_data.dart';
import 'package:anonkey_frontend/src/Credentials/credential_list.dart';
import 'package:anonkey_frontend/src/Credentials/credential_list_view.dart';
import 'package:anonkey_frontend/src/Folders/folder_list.dart';
import 'package:anonkey_frontend/src/Folders/folder_list_view_widget.dart';
import 'package:anonkey_frontend/src/Widgets/home_all_credentials_display.dart';
import 'package:anonkey_frontend/src/Widgets/home_folders_display.dart';
import 'package:anonkey_frontend/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settings/settings_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.controller, required this.index});

  final SettingsController controller;
  final int index;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int currentPageIndex;
  late final SettingsController _controller;
  late Future<CombinedListData> combinedData;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    currentPageIndex = widget.index;
    _initializeSettings();
    combinedData = Future.wait([CredentialList.getFromAPIFull(), FolderList.getFromAPIFull()]).then(
      (results) {
        return CombinedListData(credentials: results[0] as CredentialList, folders: results[1] as FolderList);
      },
    );
  }

  Future<void> _initializeSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentPageIndex = prefs.getInt("site") ?? widget.index;
    });
    prefs.remove("site");
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnonKey'),
        backgroundColor: theme.colorScheme.primary,
        //actions: //TODO: Refresh Button,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: theme.colorScheme.tertiary,
        indicatorColor: theme.colorScheme.onTertiary,
        selectedIndex: currentPageIndex,
        animationDuration: const Duration(milliseconds: 200),
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.lock),
            icon: Icon(Icons.lock_outline),
            label: 'Passwords',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
      body: <Widget>[
        /// Home
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to AnonKey',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              FutureBuilder<CombinedListData>(
                future: combinedData,
                builder: (context, snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                    children = <Widget>[
                      Card(
                        margin: const EdgeInsets.all(8.0),
                        elevation: 3,
                        color: theme.colorScheme.tertiary,
                        child: InkWell(
                          onTap: () => {
                            setState(
                              () {
                                currentPageIndex = 1;
                              },
                            )
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.shield,
                              color: theme.colorScheme.onPrimary,
                            ),
                            title: Text(
                              'Total Passwords',
                              style: TextStyle(color: theme.colorScheme.onPrimary),
                            ),
                            subtitle: Text(
                              'You have ${snapshot.data!.credentials?.byIDList.length ?? 0} passwords saved',
                              style: TextStyle(color: theme.colorScheme.onPrimary),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                      /* Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Security Tips'),
                  subtitle:
                      const Text('Keep your passwords strong and unique.'),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: theme.colorScheme.primary),
                ),
              ), */
                      const SizedBox(height: 20),
                      /* CredentialListWidget(
                        credentials: snapshot.data!.credentials!,
                        availableFolders: snapshot.data!.folders,
                        currentFolderUuid: "",
                      ), */
                      HomeFoldersDisplayWidget(
                        combinedData: snapshot.data!,
                      ),
                    ];
                  } else if (snapshot.hasError) {
                    children = <Widget>[
                      Center(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 60,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text('Error: ${snapshot.error}'),
                            ),
                          ],
                        ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    ),
                  );
                },
              ),
              /* Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Work'),
                  subtitle: const Text('12 passwords'),
                  trailing: Icon(Icons.arrow_forward_ios, color: theme.colorScheme.primary),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Google'),
                  subtitle: const Text('8 passwords'),
                  trailing: Icon(Icons.arrow_forward_ios, color: theme.colorScheme.primary),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Private'),
                  subtitle: const Text('22 passwords'),
                  trailing: Icon(Icons.arrow_forward_ios, color: theme.colorScheme.primary),
                ),
              ), */
              /* const SizedBox(height: 20),
              Text(
                'Favorites',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('Netflix Account'),
                  subtitle: const Text('username@gmail.com'),
                  trailing:
                      Icon(Icons.more_vert, color: theme.colorScheme.primary),
                ),
              ), */
            ],
          ),
        ),

        /// Passwords
        ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            FutureBuilder<CombinedListData>(
              future: combinedData,
              builder: (context, snapshot) {
                List<Widget> children;
                if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                  children = <Widget>[
                    HomeCredentialsDisplayWidget(combinedData: snapshot.data!),
                  ];
                } else if (snapshot.hasError) {
                  children = <Widget>[
                    Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error: ${snapshot.error}'),
                          ),
                        ],
                      ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                );
              },
            ),
          ],
        ),

        /// Settings
        ListView(
          children: [
            SizedBox(
              height: 800.0, // Set a valid height
              child: RepaintBoundary(
                child: SettingsView(controller: _controller), // Replace with your actual widget
              ),
            )
          ],
        ),
      ][currentPageIndex],
    );
  }
}
