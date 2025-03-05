import 'package:flutter/material.dart';

class ButtonWithThrobber extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Future<void> Function()? onPressedAsync;
  final ButtonStyle style;
  final Icon? icon;

  const ButtonWithThrobber({
    super.key,
    required this.text,
    this.onPressed,
    this.onPressedAsync,
    this.icon,
    this.style = const ButtonStyle(),
  }) : assert(
         onPressed != null || onPressedAsync != null,
         'Either onPressed or onPressedAsync must be provided',
       );

  @override
  _ButtonWithThrobberState createState() => _ButtonWithThrobberState();
}

class _ButtonWithThrobberState extends State<ButtonWithThrobber> {
  bool _isLoading = false;

  Future<void> _functionWrapper() async {
    setState(() {
      _isLoading = true;
    });

    if (widget.onPressed != null) {
      widget.onPressed!();
    } else if (widget.onPressedAsync != null) {
      await widget.onPressedAsync!();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.icon != null) {
      return ElevatedButton.icon(
        onPressed: _isLoading ? null : _functionWrapper,
        style: widget.style,
        icon: widget.icon!,
        label:
            _isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Text(widget.text),
      );
    }
    return ElevatedButton(
      onPressed: _isLoading ? null : _functionWrapper,
      style: widget.style,
      child:
          _isLoading
              ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
              : Text(widget.text),
    );
  }
}
