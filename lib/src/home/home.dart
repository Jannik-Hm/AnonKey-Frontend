import 'package:anonkey_frontend/Utility/combined_future_data.dart';
import 'package:anonkey_frontend/Utility/notification_popup.dart';
import 'package:anonkey_frontend/src/Credentials/credential_list.dart';
import 'package:anonkey_frontend/src/Credentials/trash-can/credential_list_view.dart';
import 'package:anonkey_frontend/src/Folders/folder_list.dart';
import 'package:anonkey_frontend/src/Widgets/clickable_tile.dart';
import 'package:anonkey_frontend/src/Widgets/home_all_credentials_display.dart';
import 'package:anonkey_frontend/src/Widgets/home_folders_display.dart';
import 'package:anonkey_frontend/src/Widgets/refresh_button.dart';
import 'package:anonkey_frontend/src/exception/auth_exception.dart';
import 'package:anonkey_frontend/src/exception/missing_build_context_exception.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:anonkey_frontend/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

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
    combinedData = Future.wait([
      CredentialList.getFromAPIFull().catchError((e) {
          if (mounted) {
        if( e is CredentialListTimeout ) {
            NotificationPopup.popupErrorMessage(
              context: context,
              message:
                  (context.mounted)
                      ? AppLocalizations.of(context)!.credentialFetchTimeout
                      : "Timeout Error",
            );
          return e.fallbackData;
        } else if( e is AuthException) {
          AuthService.deleteAuthenticationCredentials().then((_) {
            if (mounted) {
              context.push("/login");
            }else {
              throw MissingBuildContextException();
            }
          },);
          return null;
        }
          } else {
            throw MissingBuildContextException();
          }
      }),
      FolderList.getFromAPIFull().catchError((e) {
        if (mounted) {
          if(e is FolderListTimeout) {
            NotificationPopup.popupErrorMessage(
              context: context,
              message:
                  (context.mounted)
                      ? AppLocalizations.of(context)!.folderFetchTimeout
                      : "Timeout Error",
            );
          } else if( e is AuthException) {
          AuthService.deleteAuthenticationCredentials().then((_) {
            if (mounted) {
              context.push("/login");
            }else {
              throw MissingBuildContextException();
            }
          },);
          return null;
        }
        } else {
          throw MissingBuildContextException();
        }
        return (e as FolderListTimeout).fallbackData;
      }),
    ]).then((results) {
      return CombinedListData(
        credentials: results[0] as CredentialList,
        folders: results[1] as FolderList,
      );
    });
  }

  Future<void> _initializeSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentPageIndex = prefs.getInt("site") ?? widget.index;
    });
    prefs.remove("site");
  }

  Future<void> onFolderDelete(bool recursive) async {
    combinedData.then((data) {
      setState(() {
        combinedData = Future.wait([
          data.credentials!.updateFromAPIFull().catchError((e) {
            if (mounted) {
              NotificationPopup.popupErrorMessage(
                context: context,
                message:
                    (context.mounted)
                        ? AppLocalizations.of(context)!.credentialFetchTimeout
                        : "Timeout Error",
              );
            } else {
              throw MissingBuildContextException();
            }
            return (e as CredentialListTimeout).fallbackData;
          }, test: (error) => error is CredentialListTimeout),
        ]).then((results) {
          return CombinedListData(
            credentials: results[0] as CredentialList,
            folders: data.folders,
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AnonKey',
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          RefreshButton(
            onRefreshCallback: () {
              combinedData.then((data) {
                setState(() {
                  combinedData = Future.wait([
                    data.credentials!.updateFromAPIFull().catchError((e) {
                      if (context.mounted) {
                        if (e is CredentialListTimeout) {
                        NotificationPopup.popupErrorMessage(
                          context: context,
                          message:
                              (context.mounted)
                                  ? AppLocalizations.of(
                                    context,
                                  )!.credentialFetchTimeout
                                  : "Timeout Error",
                        );
                        return e.fallbackData;
                        } else if( e is AuthException) {
                          AuthService.deleteAuthenticationCredentials().then((_) {
                            if (context.mounted) {
                              context.push("/login");
                            }else {
                              throw MissingBuildContextException();
                            }
                          },);
                          return null;
                        }
                      } else {
                        throw MissingBuildContextException();
                      }
                    }),
                    FolderList.getFromAPIFull().catchError((e) {
                      if (context.mounted) {
                        if( e is FolderListTimeout) {
                        NotificationPopup.popupErrorMessage(
                          context: context,
                          message:
                              (context.mounted)
                                  ? AppLocalizations.of(
                                    context,
                                  )!.folderFetchTimeout
                                  : "Timeout Error",
                        );
                        return e.fallbackData;
                        } else if( e is AuthException) {
                          AuthService.deleteAuthenticationCredentials().then((_) {
                            if (context.mounted) {
                              context.push("/login");
                            }else {
                              throw MissingBuildContextException();
                            }
                          },);
                          return null;
                        }
                      } else {
                        throw MissingBuildContextException();
                      }
                    }),
                  ]).then((results) {
                    return CombinedListData(
                      credentials: results[0] as CredentialList,
                      folders: results[1] as FolderList,
                    );
                  });
                });
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: theme.colorScheme.tertiary,
        indicatorColor: theme.colorScheme.primary,
        selectedIndex: currentPageIndex,
        animationDuration: const Duration(milliseconds: 200),
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.home),
            icon: const Icon(Icons.home_outlined),
            label: AppLocalizations.of(context)!.homeMenu,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.lock),
            icon: const Icon(Icons.lock_outlined),
            label: AppLocalizations.of(context)!.passwordsMenu,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.delete),
            icon: const Icon(Icons.delete_outlined),
            label: AppLocalizations.of(context)!.trashMenu,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.settings),
            icon: const Icon(Icons.settings_outlined),
            label: AppLocalizations.of(context)!.settingsMenu,
          ),
        ],
      ),
      body:
          <Widget>[
            /// Home
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.welcomeText,
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<CombinedListData>(
                      future: combinedData,
                      builder: (context, snapshot) {
                        List<Widget> children;
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          children = <Widget>[
                            ClickableTile(
                              leading: Icon(
                                Icons.shield,
                                color: theme.colorScheme.onTertiary,
                              ),
                              title: Text(
                                AppLocalizations.of(
                                  context,
                                )!.totalPasswordsTitle,
                                style: TextStyle(
                                  color: theme.colorScheme.onTertiary,
                                ),
                              ),
                              subTitle: Text(
                                AppLocalizations.of(
                                  context,
                                )!.totalPasswordsSubTitle(
                                  snapshot.data!.credentials?.byIDList.length ??
                                      0,
                                ),
                                style: TextStyle(
                                  color: theme.colorScheme.onTertiary,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: theme.colorScheme.onTertiary,
                              ),
                              onTap:
                                  () => {
                                    setState(() {
                                      currentPageIndex = 1;
                                    }),
                                  },
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
                            //const SizedBox(height: 0),
                            ClickableTile(
                              leading: Icon(
                                Icons.delete,
                                color: theme.colorScheme.onTertiary,
                              ),
                              title: Text(
                                AppLocalizations.of(
                                  context,
                                )!.trashPasswordsTitle,
                                style: TextStyle(
                                  color: theme.colorScheme.onTertiary,
                                ),
                              ),
                              subTitle: Text(
                                AppLocalizations.of(
                                  context,
                                )!.trashPasswordsSubTitle(
                                  snapshot
                                          .data!
                                          .credentials
                                          ?.deletedList
                                          .length ??
                                      0,
                                ),
                                style: TextStyle(
                                  color: theme.colorScheme.onTertiary,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: theme.colorScheme.onTertiary,
                              ),
                              onTap:
                                  () => {
                                    setState(() {
                                      currentPageIndex = 2;
                                    }),
                                  },
                            ),
                            const SizedBox(height: 20),
                            /* CredentialListWidget(
                        credentials: snapshot.data!.credentials!,
                        availableFolders: snapshot.data!.folders,
                        currentFolderUuid: "",
                      ), */
                            HomeFoldersDisplayWidget(
                              combinedData: snapshot.data!,
                              onDeleteCallback: onFolderDelete,
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
                          children = <Widget>[
                            const Center(
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  AppLocalizations.of(context)!.awaitingResult,
                                ),
                              ),
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
            ),

            /// Passwords
            ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                FutureBuilder<CombinedListData>(
                  future: combinedData,
                  builder: (context, snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      children = <Widget>[
                        HomeCredentialsDisplayWidget(
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
                      children = <Widget>[
                        const Center(
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              AppLocalizations.of(context)!.awaitingResult,
                            ),
                          ),
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

            /// Trash
            ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                Text(
                  AppLocalizations.of(context)!.trashMenu,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                FutureBuilder<CombinedListData>(
                  future: combinedData,
                  builder: (context, snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      children = <Widget>[
                        CredentialTrashListWidget(
                          credentials: snapshot.data!.credentials!,
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
                      children = <Widget>[
                        const Center(
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              AppLocalizations.of(context)!.awaitingResult,
                            ),
                          ),
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
              padding: const EdgeInsets.all(8.0),
              children: [
                SizedBox(
                  height: 800.0, // Set a valid height
                  child: RepaintBoundary(
                    child: SettingsView(controller: _controller),
                  ),
                ),
              ],
            ),
          ][currentPageIndex],
    );
  }
}
