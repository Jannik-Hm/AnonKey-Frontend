import 'package:flutter/material.dart';

class LoginInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;

  const LoginInput(
      {super.key,
      required this.controller,
      required this.label,
      required this.obscureText});

  @override
  State<StatefulWidget> createState() => _LoginInput();
}

class _LoginInput extends State<LoginInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30.0, top: 0.0, right: 30.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
              border: InputBorder.none,
              labelText: widget.label,
              labelStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
        ),
      ),
    );
  }
}
