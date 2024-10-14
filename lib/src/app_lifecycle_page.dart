import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:ansi_styles/ansi_styles.dart';
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
    getSplash();
  }

  Future<void> getSplash() async {
    bool tempSplash = await AuthService.isSoftLogout();
    setState(() {
      isSplash = !tempSplash;
    });
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

    if (skipSplashScreen == "true" && state == AppLifecycleState.resumed) {
      await storage.write(key: "skipSplashScreen", value: "false");
    }

    if (skipSplashScreen == "false") {
      setState(() {
        _notification = state;
      });
      if (state == AppLifecycleState.resumed) {
        if (!isSplash) {
          print(AnsiStyles.red("Pushing to Splash"));
          isSplash = true;
          context.push("/splash").then(
            (didPop) {
              if (didPop as bool) {
                isSplash = false;
              }
            },
          );
        }
      }
      if (state == AppLifecycleState.paused ||
          state == AppLifecycleState.inactive) {
        await AuthService.softLogout();
        getSplash();
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
