import 'package:anonkey_frontend/Utility/api_base_data.dart';
import 'package:anonkey_frontend/Utility/notification_popup.dart';
import 'package:anonkey_frontend/api/lib/api.dart';
import 'package:anonkey_frontend/src/Auth/login_view.dart';
import 'package:anonkey_frontend/src/Widgets/button_with_throbber.dart';
import 'package:anonkey_frontend/src/Widgets/entry_input.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends State<LoginView> {
  final url = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();

  final _urlFocus = FocusNode();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    const Image(
                      image: AssetImage('assets/images/Logo.png'),
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.login,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 16),
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: EntryInput(
                        controller: url,
                        label: AppLocalizations.of(context)!.url,
                        obscureText: false,
                        focus: _urlFocus,
                        validator:
                            (kDebugMode)
                                ? null
                                : ValidationBuilder().url().add((value) {
                                  if (value != null &&
                                      !value.startsWith('https://')) {
                                    return 'Only HTTPS URLs are allowed';
                                  }
                                  return null;
                                }).build(),
                        onEnterPressed: () => _usernameFocus.requestFocus(),
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
                        validator: ValidationBuilder().required().build(),
                        onEnterPressed: () => _passwordFocus.requestFocus(),
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
                        validator: ValidationBuilder().required().build(),
                        onEnterPressed: () => _showDialog,
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
                  onPressedAsync: () => _showDialog(),
                  text: AppLocalizations.of(context)!.login,
                ),
              ),
              TextButton(
                onPressed: () => context.replaceNamed("register"),
                child: Text(AppLocalizations.of(context)!.changeToRegister),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog() async {
    if (_loginFormKey.currentState!.validate()) {
      try {
        bool test = await AuthService.login(
          username.text,
          password.text,
          url.text,
        );

        if (test) {
          await ApiBaseData.setURL(url.text);
          // Ensure the preferences are saved
          if (!mounted) return;
          context.goNamed("home");
        } else {
          if (!mounted) return;
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Login failed'),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              );
            },
          );
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
}
