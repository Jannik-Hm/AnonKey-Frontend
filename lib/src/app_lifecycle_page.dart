import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppLifecyclePage extends StatefulWidget {
  const AppLifecyclePage({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<AppLifecyclePage> createState() => _AppLifecyclePageState();
}

class _AppLifecyclePageState extends State<AppLifecyclePage>
    with WidgetsBindingObserver {
  AppLifecycleState _notification = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    setState(() {
      _notification = state;
    });
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _notification = state;
      });
      context.go("/splash");
    }
    if (state == AppLifecycleState.paused) {
      setState(() {
        _notification = state;
      });
      await AuthService.softLogout();
    }
    if (state == AppLifecycleState.inactive) {
      setState(() {
        _notification = state;
      });
      await AuthService.softLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_notification == AppLifecycleState.inactive) {
      return const Scaffold(
        body: Center(
          child: Image(
            image: AssetImage('assets/images/Logo.png'),
            width: 200,
            height: 200,
          ),
        ),
      );
    }
    return widget.child;
  }
}
