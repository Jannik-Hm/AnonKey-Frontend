import 'package:anonkey_frontend/src/Auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import './login_input.dart';

class LoginController extends State<LoginView> {
  final url = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();

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
                        image: AssetImage('images/logo.png'),
                        width: 200,
                        height: 200),
                  ),
                  LoginInput(
                    controller: url,
                    label: 'URL',
                    obscureText: false,
                    validator: ValidationBuilder().url().build(),
                  ),
                  const SizedBox(height: 16),
                  LoginInput(
                    controller: username,
                    label: 'Username',
                    obscureText: false,
                    validator: ValidationBuilder().required().build(),
                  ),
                  const SizedBox(height: 16),
                  LoginInput(
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
              onPressed: () {
                if (_loginFormKey.currentState!.validate()) {
                  //ScaffoldMessenger.of(context).showSnackBar(
                  //  const SnackBar(content: Text('Processing Data')));
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        // Retrieve the text the that user has entered by using the
                        // TextEditingController.
                        content: Text("${username.text} ${password.text}"),
                      );
                    },
                  );
                }
              },
              child: const Text('Fly me to the moon'),
            )
          ],
        ),
      ),
    );
  }

  _showDialog() {
    if (_loginFormKey.currentState!.validate()) {
      //ScaffoldMessenger.of(context).showSnackBar(
      //  const SnackBar(content: Text('Processing Data')));
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // Retrieve the text the that user has entered by using the
            // TextEditingController.
            content: Text("${username.text} ${password.text}"),
          );
        },
      );
    }
  }
}
