import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  late bool isSplash;

  late AppLifecycleState _notification;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    isSplash = false;
    _notification = AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    String? skipSplashScreen = await storage.read(key: "skipSplashScreen");

    if (skipSplashScreen == "false") {
      setState(() {
        _notification = state;
      });
      if (state == AppLifecycleState.resumed) {
        if (!isSplash && context.mounted) {
          isSplash = true;
          context.push("/splash").then(
            (didPop) {
              if (didPop != null && didPop as bool) {
                isSplash = false;
              }
            },
          );
        }
      }
      if (state == AppLifecycleState.paused ||
          state == AppLifecycleState.inactive) {
        await AuthService.softLogout();
      }
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
