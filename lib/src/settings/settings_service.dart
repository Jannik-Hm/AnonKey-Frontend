import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async => ThemeMode.system;

  Future<Locale> languageMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String defaultLocale = Platform.localeName.split("_").first;
    if (Locales.supportedLocales.contains(Locale(defaultLocale)) &&
        prefs.getString("language_code") == null) {
      prefs.setString("language_code", defaultLocale);
    }
    final languageCode = prefs.getString('language_code') ?? 'en';
    return Locale(languageCode);
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('site', 3);
  }
}
