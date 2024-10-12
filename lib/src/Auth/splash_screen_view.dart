import 'package:anonkey_frontend/Utility/notification_popup.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/Widgets/entry_input.dart';
import 'package:anonkey_frontend/src/exception/auth_exception.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  final password = TextEditingController();
  final _passwordFocus = FocusNode();
  final _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/images/Logo.png'), width: 200, height: 200),
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
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () => _loginWithoutUsername(context),
              child: const Text('Fly me to the moon'),
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
        final Map<String, String> credentials = await AuthService.getAuthenticationCredentials();
        bool req = await AuthService.login(credentials["username"]!, password.text, prefs.getString("url") ?? "");
        if (req) {
          if (context.mounted) {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed("home");
            }
          }
        } else {
          if (context.mounted) {
            NotificationPopup.popupErrorMessage(context: context, message: "Login failed");
          }
        }
      } on NoCredentialException {
        if (context.mounted) {
          context.goNamed("login");
        }
      } on ApiException catch (e) {
        if (context.mounted) {
          NotificationPopup.apiError(context: context, apiResponseMessage: e.message);
        }
      }
    }
  }
}
