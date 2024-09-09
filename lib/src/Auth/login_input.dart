import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class LoginInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final VoidCallback? onEnterPressed;
  final StringValidationCallback? validator;

  const LoginInput(
      {super.key,
      required this.controller,
      required this.label,
      required this.obscureText,
      this.onEnterPressed,
      this.validator});

  @override
  State<StatefulWidget> createState() => _LoginInput();
}

class _LoginInput extends State<LoginInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 5.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: TextFormField(
          onFieldSubmitted: (value) {
            if (widget.onEnterPressed != null) {
              widget.onEnterPressed!();
            }
          },
          validator: widget.validator,
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
