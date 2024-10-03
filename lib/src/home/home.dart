import 'package:anonkey_frontend/src/Auth/login_controller.dart';
import 'package:anonkey_frontend/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    currentPageIndex = widget.index;
    _initializeSettings();
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
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(255, 140, 156, 224),
        selectedIndex: currentPageIndex,
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
              Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.shield),
                  title: const Text('Total Passwords'),
                  subtitle: const Text('You have 42 passwords saved'),
                  trailing:
                      Icon(Icons.visibility, color: theme.colorScheme.primary),
                ),
              ),
              Card(
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
              ),
              const SizedBox(height: 20),
              Text(
                'Folders',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Work'),
                  subtitle: const Text('12 passwords'),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: theme.colorScheme.primary),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Google'),
                  subtitle: const Text('8 passwords'),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: theme.colorScheme.primary),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Private'),
                  subtitle: const Text('22 passwords'),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: theme.colorScheme.primary),
                ),
              ),
              const SizedBox(height: 20),
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
              ),
            ],
          ),
        ),

        /// Passwords
        ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            Text(
              'Passwords',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Google Account'),
              subtitle: Text('username@gmail.com'),
              trailing: Icon(Icons.more_vert),
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
