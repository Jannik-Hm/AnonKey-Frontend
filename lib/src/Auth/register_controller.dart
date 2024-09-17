import 'package:anonkey_frontend/src/Auth/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'login_input.dart';

class RegisterControllerState extends State<RegisterView> {
  final url = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();

  final _urlFocus = FocusNode();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();

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
            LoginInput(
                controller: url,
                label: "URL",
                obscureText: false,
                focus: _urlFocus),
            const SizedBox(height: 16),
            LoginInput(
                controller: username,
                label: "Username",
                obscureText: false,
                focus: _usernameFocus),
            const SizedBox(height: 16),
            LoginInput(
              controller: password,
              label: "Passwort",
              obscureText: false,
              focus: _passwordFocus,
            )
          ],
        ),
      ),
    );
  }
}
