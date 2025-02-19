// lib/src/utils/auth_utils.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> checkBiometricAvailability() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool canCheckBiometrics = await _auth.canCheckBiometrics;
    bool isBiometric = prefs.getBool('isBiometricEnabled') ?? false;
    return isBiometric && canCheckBiometrics;
  }

  static Future<bool> biometricRender(BuildContext context) async {
    try {
      bool canCheckBiometrics = await _auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.biometricNotAvailable),
          ),
        );
        return false;
      }

      bool authenticated = await _auth.authenticate(
        localizedReason: AppLocalizations.of(context)!.loginWithBiometrics,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (authenticated) {
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.biometricFailed),
          ),
        );
        return false;
      }
    } on PlatformException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.biometricNotAvailable),
        ),
      );
      return false;
    }
  }
}
