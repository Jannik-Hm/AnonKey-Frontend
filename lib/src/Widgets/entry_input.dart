import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class EntryInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final VoidCallback? onEnterPressed;
  final StringValidationCallback? validator;
  final FocusNode focus;
  final bool enabled;

  const EntryInput({
    super.key,
    required this.controller,
    required this.label,
    required this.obscureText,
    this.onEnterPressed,
    this.validator,
    required this.focus,
    this.enabled = true,
  });

  @override
  State<StatefulWidget> createState() => _EntryInput();
}

class _EntryInput extends State<EntryInput> {
  late bool _enabled;
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _enabled = widget.enabled;
    _obscure = widget.obscureText;
  }

  void _show() {
    setState(() {
      _obscure = false;
    });
  }

  void _hide() {
    setState(() {
      _obscure = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 5.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              enabled: _enabled,
              focusNode: widget.focus,
              onFieldSubmitted: (value) {
                if (widget.onEnterPressed != null) {
                  widget.onEnterPressed!();
                }
              },
              validator: widget.validator,
              controller: widget.controller,
              obscureText: _obscure,
              decoration: InputDecoration(border: InputBorder.none, labelText: widget.label, labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
            ),
          ),
          if (widget.obscureText)
            IconButton(
              icon: Icon(
                (_obscure) ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              onPressed: () => (_obscure) ? _show() : _hide(),
              style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary, foregroundColor: Theme.of(context).colorScheme.onSecondary),
            ),
        ],
      ),
    );
  }
}
