import 'package:anonkey_frontend/Utility/auth_utils.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService) {
    _loadBiometricSetting();
    password.addListener(() {
      isPasswordEmpty.value = password.text.isEmpty;
    });
  }

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  final TextEditingController password = TextEditingController();
  final ValueNotifier<bool> isPasswordEmpty = ValueNotifier<bool>(true);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);
  final ValueNotifier<bool> isBiometricEnabled = ValueNotifier<bool>(false);

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;

  late Locale _languageMode;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;

  Locale get languageMode => _languageMode;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _languageMode = await _settingsService.languageMode();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(
      ThemeMode? newThemeMode, BuildContext context) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<Locale> language() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    return Locale(languageCode);
  }

  Future<void> updateLanguage(Locale language) async {
    var prefs = await SharedPreferences.getInstance();
    if (_languageMode == language) {
      return;
    }
    if (language == const Locale("de")) {
      _languageMode = const Locale("de");
      await prefs.setString('language_code', 'de');
      await prefs.setString('countryCode', 'de');
    } else {
      _languageMode = const Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    }
    await prefs.setInt('site', 3);
    notifyListeners();
  }

  Future<void> _loadBiometricSetting() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isBiometricEnabled.value = prefs.getBool('isBiometricEnabled') ?? false;
  }

  Future<void> updateBiometricSetting(
      BuildContext context, bool isEnabled) async {
    try {
      await AuthService.setSkipSplashScreen(true);
      await AuthUtils.loginWithBiometrics(context);
    } catch (e) {
      errorMessage.value = e.toString();
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isBiometricEnabled', isEnabled);
    isBiometricEnabled.value = isEnabled;
  }
}
