import 'package:anonkey_frontend/src/Auth/login_view.dart';
import 'package:flutter/material.dart';

class LoginController extends State<LoginView>{

  final myController = TextEditingController();

 @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  final username = TextEditingController();
  final password = TextEditingController();

@override
  Widget build(BuildContext build){
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Login View'),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: TextFormField(
              controller: username,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Username'
              ),
            )
          ),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: TextFormField(
              controller: password,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Password'
              ),
            )
          ),
          Text(password.text),

        ],
      )),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
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
        tooltip: 'Show me the value!',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}

