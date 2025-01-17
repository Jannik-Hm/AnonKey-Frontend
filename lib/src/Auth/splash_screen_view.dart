import 'package:anonkey_frontend/Utility/notification_popup.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/Widgets/entry_input.dart';
import 'package:anonkey_frontend/src/exception/auth_exception.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:anonkey_frontend/src/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  final password = TextEditingController();
  final _passwordFocus = FocusNode();
  final _loginFormKey = GlobalKey<FormState>();
  final LocalAuthentication auth = LocalAuthentication();
  bool _isBiometricAvailable = false;
  late bool notFirstTry;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    if (_isBiometricAvailable) _loginWithBiometrics(context);
    notFirstTry = false;
  }

  Future<void> _checkBiometricAvailability() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      canCheckBiometrics = false;
    }
    bool isBiometric = prefs.getBool('isBiometricEnabled') ?? false;
    setState(() {
      _isBiometricAvailable = isBiometric && canCheckBiometrics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Remove 'Back' Button of context.push()
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
                image: AssetImage('assets/images/Logo.png'),
                width: 200,
                height: 200),
            const SizedBox(height: 16),
            Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: EntryInput(
                        controller: password,
                        label: AppLocalizations.of(context)!.password,
                        obscureText: true,
                        focus: _passwordFocus,
                        validator: ValidationBuilder().required().build(),
                        onEnterPressed: () => _loginWithoutUsername(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                )),
            const SizedBox(height: 16),
            if (_isBiometricAvailable)
              ElevatedButton.icon(
                onPressed: () => _loginWithBiometrics(context),
                icon: const Icon(Icons.fingerprint),
                label: Text(AppLocalizations.of(context)!.loginWithBiometrics),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            const SizedBox(height: 16),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () => _loginWithoutUsername(context),
              child: const Text('Fly me to the moon'),
            ),
            const SizedBox(height: 20),
            if (notFirstTry)
              ElevatedButton.icon(
                key: UniqueKey(),
                onPressed: () => UserService.logout(context),
                icon: const Icon(Icons.logout),
                label: Text(AppLocalizations.of(context)!.logout),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _loginWithoutUsername(BuildContext context) async {
    if (_loginFormKey.currentState!.validate()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        final AuthenticationCredentialsSingleton credentials =
            await AuthService.getAuthenticationCredentials();
        bool req = await AuthService.login(
            credentials.username!, password.text, prefs.getString("url") ?? "");
        if (req) {
          if (context.mounted) {
            if (context.canPop()) {
              context.pop(true);
            } else {
              context.goNamed("home");
            }
          }
        } else {
          setState(() {
            notFirstTry = true;
          });
          if (context.mounted) {
            NotificationPopup.popupErrorMessage(
                context: context, message: "Login failed");
          }
        }
      } on NoCredentialException {
        if (context.mounted) {
          context.goNamed("login");
        }
      } on ApiException catch (e) {
        if (context.mounted) {
          NotificationPopup.apiError(
              context: context, apiResponseMessage: e.message);
        }
      }
    }
  }

  Future<void> _loginWithBiometrics(BuildContext context) async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.biometricNotAvailable)),
        );
        return;
      }

      bool authenticated = await auth.authenticate(
        localizedReason: AppLocalizations.of(context)!.loginWithBiometrics,
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final AuthenticationCredentialsSingleton credentials =
            await AuthService.getAuthenticationCredentials();
        bool req = await AuthService.login(credentials.username!,
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
          setState(() {
            notFirstTry = true;
          });
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
    } on PlatformException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.biometricNotAvailable)),
      );
    }
  }
}
