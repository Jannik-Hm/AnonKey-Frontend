import 'package:flutter/material.dart';

class RefreshButton extends StatefulWidget {
  final Function() onRefreshCallback;

  const RefreshButton({
    super.key,
    required this.onRefreshCallback,
  });

  @override
  State<StatefulWidget> createState() => _RefreshButton();
}

class _RefreshButton extends State<RefreshButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // The duration of the rotation
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Always dispose the controller to free up resources
    super.dispose();
  }

  Future<void> refresh() async {
    widget.onRefreshCallback();
    if (_controller.isAnimating) {
      return; // Prevent triggering multiple animations
    }
    _controller
        .forward(from: 0.0); // Start from the beginning
        //.then((_) => _controller.reverse()); // Reset the animation after completion (optional)
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2.0 * 3.14159265359, // Full rotation (2 * pi radians)
          child: child, // The icon button to rotate
        );
      },
      child: IconButton(
        onPressed: () {
          refresh();
        },
        icon: Icon(Icons.refresh, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
