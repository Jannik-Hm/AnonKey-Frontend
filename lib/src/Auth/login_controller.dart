import 'package:anonkey_frontend/src/Auth/login_view.dart';
import 'package:flutter/material.dart';

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
          FractionallySizedBox(
              widthFactor: 0.5,
              child: TextFormField(
                controller: username,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Username'),
              )),
          FractionallySizedBox(
              widthFactor: 0.5,
              child: TextFormField(
                obscureText: true,
                controller: password,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Password'),
              )),
          Text(password.text),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary),
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
