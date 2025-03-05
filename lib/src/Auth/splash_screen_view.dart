import 'package:anonkey_frontend/Utility/auth_utils.dart';
import 'package:anonkey_frontend/Utility/notification_popup.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/Widgets/button_with_throbber.dart';
import 'package:anonkey_frontend/src/Widgets/entry_input.dart';
import 'package:anonkey_frontend/src/exception/auth_exception.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:anonkey_frontend/src/service/user_service.dart';
import 'package:flutter/material.dart';
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
              height: 200,
            ),
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
              ),
            ),
            const SizedBox(height: 16),
            if (_isBiometricAvailable)
              ButtonWithThrobber(
                onPressedAsync: () => _loginWithBiometrics(context),
                icon: const Icon(Icons.fingerprint),
                text: AppLocalizations.of(context)!.loginWithBiometrics,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            const SizedBox(height: 16),
            ButtonWithThrobber(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressedAsync: () => _loginWithoutUsername(context),
              text: AppLocalizations.of(context)!.login,
            ),
            const SizedBox(height: 20),
            if (notFirstTry)
              ButtonWithThrobber(
                key: UniqueKey(),
                onPressed: () => UserService.logout(context),
                icon: const Icon(Icons.logout),
                text: AppLocalizations.of(context)!.logout,
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
      try {
        var bool = await AuthService.loginWithoutUserName(password.text);
        if (bool) {
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
              context: context,
              message: "Login failed",
            );
          }
        }
      } on NoTokensFoundException {
        if (context.mounted) {
          context.goNamed("login");
        }
      } on ApiException catch (e) {
        if (context.mounted) {
          NotificationPopup.apiError(
            context: context,
            apiResponseMessage: e.message,
          );
        }
      }
    }
  }

  Future<void> _loginWithBiometrics(BuildContext context) async {
    var success = await AuthUtils.biometricRender(context);
    if (success) {
      var loginSucess = await AuthService.loginWithBiometrics();
      if (loginSucess) {
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
            context: context,
            message: "Login failed",
          );
        }
      }
    }
  }
}
