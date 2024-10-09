import 'package:anonkey_frontend/src/Auth/login_controller.dart';
import 'package:anonkey_frontend/src/Auth/login_input.dart';
import 'package:anonkey_frontend/src/exception/auth_exception.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
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
            const Image(
                image: AssetImage('assets/images/Logo.png'),
                width: 200,
                height: 200),
            const SizedBox(height: 16),
            Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    LoginInput(
                        controller: password,
                        label: "Password",
                        obscureText: true,
                        validator: ValidationBuilder().required().build(),
                        focus: _passwordFocus),
                    const SizedBox(height: 16),
                  ],
                )),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary),
              onPressed: () => _loginWithoutUsername(),
              child: const Text('Fly me to the moon'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loginWithoutUsername() async {
    if (_loginFormKey.currentState!.validate()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        final Map<String, String> credientails =
            await AuthService.getAuthenticationCredentials();
        await AuthService.login(credientails["username"]!, password.text,
            prefs.getString("url") ?? "") ? context.replaceNamed("home") : null;
      } on NoCredentialException {
        context.replace("/login");
      }
    }
  }
}
