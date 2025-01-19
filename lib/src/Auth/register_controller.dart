import 'package:anonkey_frontend/Utility/notification_popup.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/Auth/register_view.dart';
import 'package:anonkey_frontend/src/Widgets/button_with_throbber.dart';
import 'package:anonkey_frontend/src/Widgets/entry_input.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterControllerState extends State<RegisterView> {
  final url = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final displayName = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();

  final _urlFocus = FocusNode();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _displayName = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                  image: AssetImage('assets/images/Logo.png'),
                  width: 200,
                  height: 200),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.register,
                style: const TextStyle(fontSize: 24),
              ),
              Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: EntryInput(
                        controller: url,
                        label: AppLocalizations.of(context)!.url,
                        obscureText: false,
                        focus: _urlFocus,
                        validator: (kDebugMode)
                            ? null
                            : ValidationBuilder().url().add((value) {
                                if (value != null &&
                                    !value.startsWith('https://')) {
                                  return 'Only HTTPS URLs are allowed';
                                }
                                return null;
                              }).build(),
                        onEnterPressed: _usernameFocus.requestFocus,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: EntryInput(
                        controller: username,
                        label: AppLocalizations.of(context)!.username,
                        obscureText: false,
                        focus: _usernameFocus,
                        validator: ValidationBuilder()
                            .required()
                            .minLength(5)
                            .maxLength(128)
                            .build(),
                        onEnterPressed: _displayName.requestFocus,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: EntryInput(
                        controller: displayName,
                        label: AppLocalizations.of(context)!.displayName,
                        obscureText: false,
                        focus: _displayName,
                        validator: ValidationBuilder().required().build(),
                        onEnterPressed: _passwordFocus.requestFocus,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: EntryInput(
                        controller: password,
                        label: AppLocalizations.of(context)!.password,
                        obscureText: true,
                        focus: _passwordFocus,
                        validator:
                            ValidationBuilder().required().minLength(5).build(),
                        onEnterPressed: () => _register,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FractionallySizedBox(
                widthFactor: 0.6,
                child: ButtonWithThrobber(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressedAsync: () => _register(),
                  text: AppLocalizations.of(context)!.register,
                ),
              ),
              TextButton(
                onPressed: () => context.replaceNamed("login"),
                child: Text(AppLocalizations.of(context)!.changeToLogin),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _register() async {
    try {
      if (_loginFormKey.currentState!.validate()) {
        bool isRegistered = await AuthService.register(
            username.text, password.text, displayName.text, url.text);
        if (isRegistered) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('url', url.text);
          if (!mounted) return;
          context.goNamed('home');
        }
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        NotificationPopup.apiError(
            context: context, apiResponseMessage: e.message);
      }
    }
  }
}
