import 'package:anonkey_frontend/src/Credentials/credential_list.dart';
import 'package:anonkey_frontend/src/Credentials/list-entry/credential_entry.dart';
import 'package:flutter/material.dart';

class CredentialListWidget extends StatefulWidget {
  final Future<CredentialList?> credentials;

  const CredentialListWidget({
    super.key,
    required this.credentials,
  });

  @override
  State<StatefulWidget> createState() => _CredentialListWidget();
}

class _CredentialListWidget extends State<CredentialListWidget> {
  final double spacing = 16.0;

  late Future<CredentialList?> credentials;

  @override
  void initState() {
    super.initState();
    credentials = widget.credentials;
    // Initialize the mutable object from the widget field
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CredentialList?>(
        future: credentials,
        builder: (context, snapshot) {
          List<Widget> children;
          print(snapshot.data);
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            children = <Widget>[
              CredentialEntry(
                credential: snapshot.data!.byIDList["ebd1ef35-cade-4e2a-8117-3ed58bd13143"]!,
                onSaveCallback: (credential) {
                  setState(() {
                    credentials = snapshot.data!.updateFromLocalObject(credential: credential);
                  });
                },
              ),
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
