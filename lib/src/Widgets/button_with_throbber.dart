import 'package:flutter/material.dart';

class ButtonWithThrobber extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;
  final ButtonStyle style;

  const ButtonWithThrobber({
    super.key,
    required this.text,
    required this.onPressed,
    this.style = const ButtonStyle(),
  });

  @override
  _ButtonWithThrobberState createState() => _ButtonWithThrobberState();
}

class _ButtonWithThrobberState extends State<ButtonWithThrobber> {
  bool isLoading = false;

  Future<void> _functionWrapper() async {
    setState(() {
      isLoading = true;
    });

    await widget.onPressed();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : _functionWrapper,
      style: widget.style,
      child: isLoading
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
