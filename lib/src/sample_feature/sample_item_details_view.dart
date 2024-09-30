import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatefulWidget {
  const SampleItemDetailsView({super.key});

  static const routeName = '/sample_item';

  @override
  _SampleItemDetailsViewState createState() => _SampleItemDetailsViewState();
}

class _SampleItemDetailsViewState extends State<SampleItemDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () => _logout(),
          child: const Text("Logout"),
        ),
      ),
    );
  }

  void _logout() async {
    await AuthService.deleteAuthenticationCredentials();
    if (!mounted) return;
    context.replaceNamed("login");
  }
}
