import 'package:anonkey_frontend/src/Auth/login_view.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './login_input.dart';

class LoginController extends State<LoginView> {
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
            Form(
                key: _loginFormKey,
                child: Column(children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: const Image(
                        image: AssetImage('assets/images/Logo.png'),
                        width: 200,
                        height: 200),
                  ),
                  LoginInput(
                    focus: _urlFocus,
                    controller: url,
                    label: 'URL',
                    obscureText: false,
                    validator: (kDebugMode) ? null : ValidationBuilder().url().build(),
                    onEnterPressed: () => _usernameFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),
                  LoginInput(
                    focus: _usernameFocus,
                    controller: username,
                    label: 'Username',
                    obscureText: false,
                    validator: ValidationBuilder().required().build(),
                    onEnterPressed: () => _passwordFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),
                  LoginInput(
                    focus: _passwordFocus,
                    controller: password,
                    label: 'Password',
                    obscureText: true,
                    validator: ValidationBuilder().required().build(),
                    onEnterPressed: () => _showDialog(),
                  ),
                  Text(password.text),
                ])),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary),
              onPressed: () => _showDialog(),
              child: const Text('Fly me to the moon'),
            )
          ],
        ),
      ),
    );
  }

  _showDialog() async {
    if (_loginFormKey.currentState!.validate()) {

      bool test = await AuthService.login(username.text, password.text,url.text);

      if (test) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('url', url.text);
        if (!mounted) return;
        Navigator.pushNamed(context, '/home');
      } else {
        if (!mounted) return;
        return showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              // Retrieve the text the that user has entered by using the
              // TextEditingController.
              content: Text('Login failed'),
            );
          },
        );
      }
    }
  }
// Todo implement login function
}
