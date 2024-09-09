import 'package:anonkey_frontend/src/Auth/login_view.dart';
import 'package:flutter/material.dart';

import './login_input.dart';

class LoginController extends State<LoginView> {
  final username = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Image(
              image: AssetImage('images/logo.png'), width: 200, height: 200),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          login_input(controller: username, label: 'Username', obscureText: false),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          login_input(controller: password, label: 'Password', obscureText: true),
          Text(password.text),
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
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
            },
            child: const Text('Fly me to the moon'),
          )
        ],
      )),
    );
  }
}
