import 'package:anonkey_frontend/src/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          debugShowCheckedModeBanner: false,

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: Locales.supportedLocales,

          locale: settingsController.languageMode,

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define the routes for your application. The "/" route is the home

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue.shade600,
            surface: Colors.grey.shade50,
            secondary: Colors.grey.shade200,
            onSecondary: Colors.grey.shade700,
            tertiary: Colors.grey.shade100,
            onTertiary: Colors.grey.shade800,
          ),
          navigationBarTheme: NavigationBarThemeData(
                labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                  (Set<WidgetState> states) =>
                      states.contains(WidgetState.selected)
                          ? const TextStyle(color: Colors.black)
                          : const TextStyle(color: Colors.black),
                ),
                iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                  (Set<WidgetState> states) =>
                      states.contains(WidgetState.selected)
                          ? IconThemeData(color: Theme.of(context).colorScheme.onPrimary)
                          : const IconThemeData(color: Colors.black),
              ),
            ),
          ),
          darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue.shade800,
                surface: Colors.grey.shade900,
                onSurface: Colors.white,
                onPrimary: Colors.grey.shade100,
                onSecondary: Colors.grey.shade100,
                tertiary: Colors.grey.shade800,
                onTertiary: Colors.grey.shade100,
              ),
              navigationBarTheme: NavigationBarThemeData(
                labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                  (Set<WidgetState> states) =>
                      states.contains(WidgetState.selected)
                          ? TextStyle(color: Theme.of(context).colorScheme.onTertiary)
                          : const TextStyle(color: Colors.black),
                ),
                iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                  (Set<WidgetState> states) =>
                      states.contains(WidgetState.selected)
                          ? IconThemeData(color: Theme.of(context).colorScheme.onPrimary)
                          : const IconThemeData(color: Colors.black),
                ),
              )),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          routerConfig:
              (AppRouter(settingsController: settingsController)).getRouter(),
        );
      },
    );
  }
}

class Locales {
  static const List<Locale> supportedLocales = [
    Locale('en'), // English, no country code
    Locale('de'), // German, no country code
  ];
}
