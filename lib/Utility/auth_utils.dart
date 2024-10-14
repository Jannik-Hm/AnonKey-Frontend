// lib/src/utils/auth_utils.dart
import 'package:anonkey_frontend/src/router/clear_and_navigate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../src/service/auth_service.dart';
import 'notification_popup.dart';

class AuthUtils {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<void> logout(BuildContext context) async {
    await AuthService.deleteAuthenticationCredentials();
    if (!context.mounted) return;
    GoRouter.of(context).clearStackAndNavigate("/login");
  }

  static Future<bool> checkBiometricAvailability() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool canCheckBiometrics = await _auth.canCheckBiometrics;
    bool isBiometric = prefs.getBool('isBiometricEnabled') ?? false;
    return isBiometric && canCheckBiometrics;
  }

  static Future<void> loginWithBiometrics(BuildContext context) async {
    try {
      bool canCheckBiometrics = await _auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.biometricNotAvailable)),
        );
        return;
      }

      bool authenticated = await _auth.authenticate(
        localizedReason: AppLocalizations.of(context)!.loginWithBiometrics,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final Map<String, String> credentials =
            await AuthService.getAuthenticationCredentials();
        bool req = await AuthService.login(credentials["username"]!,
            credentials["password"]!, prefs.getString("url") ?? "");
        if (req) {
          if (context.mounted) {
            if (context.canPop()) {
              context.pop(true);
            } else {
              context.goNamed("home");
            }
          }
        } else {
          if (context.mounted) {
            NotificationPopup.popupErrorMessage(
                context: context, message: "Login failed");
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.biometricFailed)),
        );
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.biometricNotAvailable)),
      );
    }
  }
}
