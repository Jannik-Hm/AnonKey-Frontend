import 'dart:async';

import 'package:anonkey_frontend/src/router/clear_and_navigate.dart';
import 'package:anonkey_frontend/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/auth_service.dart';
import '../service/user_service.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    void deleteUser() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String url = prefs.getString("url")!;
      final String? token =
          (await AuthService.getAuthenticationCredentials()).accessToken?.token;

      bool res =
          await UserService.deleteUser(url, token!, controller.password.text);
      if (res) {
        GoRouter.of(context).clearStackAndNavigate("/login");
      } else {
        controller.errorMessage.value =
            AppLocalizations.of(context)!.deleteUserFailed;
        Timer(const Duration(seconds: 5), () {
          controller.errorMessage.value = null;
        });
      }
      controller.password.clear();
    }

    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading:
                  Icon(Icons.brightness_6, color: theme.colorScheme.onSurface),
              title: Text(AppLocalizations.of(context)!.selectTheme,
                  style: TextStyle(color: theme.colorScheme.onSurface)),
              trailing: DropdownButton<ThemeMode>(
                value: controller.themeMode,
                onChanged: (ThemeMode? newTheme) =>
                    controller.updateThemeMode(newTheme, context),
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(AppLocalizations.of(context)!.systemTheme),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(AppLocalizations.of(context)!.lightTheme),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(AppLocalizations.of(context)!.darkTheme),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.language, color: theme.colorScheme.onSurface),
              title: Text(AppLocalizations.of(context)!.language,
                  style: TextStyle(color: theme.colorScheme.onSurface)),
              trailing: DropdownButton<Locale>(
                value: controller.languageMode,
                onChanged: (Locale? newLanguage) =>
                    controller.updateLanguage(newLanguage!),
                items: [
                  DropdownMenuItem(
                    value: const Locale("de"),
                    child: Text(AppLocalizations.of(context)!.german),
                  ),
                  DropdownMenuItem(
                    value: const Locale("en"),
                    child: Text(AppLocalizations.of(context)!.english),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.openSourceLicenses,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.info, color: theme.colorScheme.onSurface),
              title: Text(AppLocalizations.of(context)!.viewLicenses,
                  style: TextStyle(color: theme.colorScheme.onSurface)),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (BuildContext context) {
                  return Theme(
                    data: (controller.themeMode == ThemeMode.dark ||
                            controller.themeMode == ThemeMode.system &&
                                MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark)
                        ? ThemeData(
                            colorScheme: ColorScheme.fromSeed(
                              seedColor: Colors.blue.shade800,
                              surface: Colors.grey.shade900,
                              onSurface: Colors.white,
                              primary: Colors.grey.shade100,
                              tertiary: Colors.grey.shade800,
                              onTertiary: Colors.grey.shade100,
                            ),
                            appBarTheme: AppBarTheme(
                              backgroundColor: Colors.grey.shade900,
                            ),
                          )
                        : Theme.of(context),
                    child: const LicensePage(
                      applicationName: "AnonKey",
                      applicationVersion: "1.0",
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: controller.isBiometricEnabled,
              builder: (context, isBiometricEnabled, child) {
                return SwitchListTile(
                  title: Text(
                      AppLocalizations.of(context)!.biometricAuthentication),
                  value: isBiometricEnabled,
                  onChanged: (bool value) {
                    controller.updateBiometricSetting(context, value);
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => UserService.logout(context),
                  icon: const Icon(Icons.logout),
                  label: Text(AppLocalizations.of(context)!.logout),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        bool isDarkTheme;
                        if (ThemeMode.system != controller.themeMode) {
                          isDarkTheme = controller.themeMode == ThemeMode.dark
                              ? true
                              : false;
                        } else {
                          var brightness =
                              MediaQuery.of(context).platformBrightness;
                          isDarkTheme = brightness == Brightness.dark;
                        }
                        return ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                          child: Container(
                            color: isDarkTheme
                                ? ThemeData.dark().scaffoldBackgroundColor
                                : ThemeData.light().scaffoldBackgroundColor,
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                              left: 16,
                              right: 16,
                              top: 16,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.deleteUser,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: controller.password,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!
                                          .password,
                                    ),
                                    obscureText: true,
                                  ),
                                  const SizedBox(height: 20),
                                  ValueListenableBuilder<String?>(
                                    valueListenable: controller.errorMessage,
                                    builder: (context, errorMessage, child) {
                                      return errorMessage != null
                                          ? Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                errorMessage,
                                                style: const TextStyle(
                                                    color: Colors.red),
                                              ),
                                            )
                                          : Container();
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  ValueListenableBuilder<bool>(
                                    valueListenable: controller.isPasswordEmpty,
                                    builder: (context, isPasswordEmpty, child) {
                                      return ElevatedButton(
                                        onPressed:
                                            isPasswordEmpty ? null : deleteUser,
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .deleteUser),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  },
                  icon: const Icon(Icons.delete),
                  label: Text(AppLocalizations.of(context)!.deleteUser),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
