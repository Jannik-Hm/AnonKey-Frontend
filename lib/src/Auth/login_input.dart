import 'package:flutter/material.dart';

class login_input extends StatefulWidget{
  final TextEditingController controller;
  final String label;
  final bool obscureText;

  login_input({required this.controller, required this.label, required this.obscureText});

  @override
  State<StatefulWidget> createState() => _login_input();
  
}

class _login_input extends State<login_input> {

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: const EdgeInsets.only(left: 30.0, top: 0.0, right: 30.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(new Radius.circular(15)),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: TextFormField(
                controller: widget.controller,
                obscureText: widget.obscureText,
                decoration: InputDecoration(border: InputBorder.none, labelText: widget.label, labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
              ),
            ),
          );
  }
}