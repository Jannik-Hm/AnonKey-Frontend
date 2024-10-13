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
    void logout() async {
      await AuthService.deleteAuthenticationCredentials();
      if (!context.mounted) return;
      GoRouter.of(context).clearStackAndNavigate("login");
    }

    void deleteUser() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String url = prefs.getString("url")!;
      final String token =
          (await AuthService.getAuthenticationCredentials())["token"]!;

      bool res =
          await UserService.deleteUser(url, token, controller.password.text);
      if (res) {
        GoRouter.of(context).clearStackAndNavigate("login");
      } else {
        controller.errorMessage.value =
            AppLocalizations.of(context)!.deleteUserFailed;
        Timer(const Duration(seconds: 5), () {
          controller.errorMessage.value = null;
        });
      }
      controller.password.clear();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Theme',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(AppLocalizations.of(context)!.selectTheme),
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
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.language),
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(AppLocalizations.of(context)!.viewLicenses),
            onTap: () => showLicensePage(context: context),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: logout,
              icon: const Icon(Icons.logout),
              label: Text(AppLocalizations.of(context)!.logout),
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    final isDarkTheme = ThemeMode.dark == controller.themeMode;
                    return ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
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
                                  labelText:
                                      AppLocalizations.of(context)!.password,
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
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                    child: Text(AppLocalizations.of(context)!
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
          )
        ],
      ),
    );
  }
}
