import 'package:anonkey_frontend/src/Auth/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_validator/form_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/auth_service.dart';
import 'login_input.dart';

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
                    LoginInput(
                        controller: url,
                        label: "URL",
                        obscureText: false,
                        //validator: ValidationBuilder().url().build(),
                        focus: _urlFocus),
                    const SizedBox(height: 16),
                    LoginInput(
                        controller: username,
                        label: "Username",
                        obscureText: false,
                        validator: ValidationBuilder()
                            .required()
                            .minLength(5)
                            .maxLength(128)
                            .build(),
                        focus: _usernameFocus),
                  const SizedBox(height: 16),
                    LoginInput(
                        controller: displayName,
                        label: "Display Name",
                        obscureText: false,
                        validator: ValidationBuilder()
                            .required()
                            .build(),
                        focus: _displayName),
                    const SizedBox(height: 16),
                    LoginInput(
                      controller: password,
                      label: "Password",
                      obscureText: true,
                      validator:
                          ValidationBuilder().required().minLength(5).build(),
                      onEnterPressed: () => _register(),
                      focus: _passwordFocus,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary),
                      onPressed: () => _register(),
                      child: const Text('Fly me to the moon'),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  _register() async {
    if (_loginFormKey.currentState!.validate()) {
      bool isRegistered =
          await AuthService.register(username.text, password.text, displayName.text);
      if (isRegistered) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('url', url.text);
        if (!mounted) return;
        Navigator.pushNamed(context, '/home');
      }
    }
  }
}
