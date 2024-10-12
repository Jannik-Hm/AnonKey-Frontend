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

class _AppLifecyclePageState extends State<AppLifecyclePage> with WidgetsBindingObserver {
  late bool isSplash;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    isSplash = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (!isSplash) {
        isSplash = true;
        context.push("/splash").then(
          (didPop) {
            if(didPop as bool){
              isSplash = false;
            }
          },
        );
      }
    }
    if (state == AppLifecycleState.paused) {
      await AuthService.softLogout();
    }
    if (state == AppLifecycleState.inactive) {
      await AuthService.softLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
