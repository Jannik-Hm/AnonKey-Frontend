import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './logo.dart';

class CredentialEntry extends StatefulWidget {
  final String url;
  final String username;
  final String password;
  final String title;

  const CredentialEntry({
    super.key,
    required this.url,
    required this.username,
    required this.password,
    required this.title,
  });

  @override
  State<StatefulWidget> createState() => _CredentialEntry();
}

class _CredentialEntry extends State<CredentialEntry> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => print("Test"),
      child: Ink(
        padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 5.0),
        color: Theme.of(context).colorScheme.tertiary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure even spacing
          children: [
            // Image on the left
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 70.0),
              //child: Image.network("https://icons.duckduckgo.com/ip3/linustechtips.com.ico"),
              child: getByteLogoFromUrl(widget.url),
            ),
            const SizedBox(
              width: 20.0,
            ),
            // Vertically stacked texts in the middle
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add some spacing between the image and text
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      widget.username,
                      style: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary, // Set the primary color from ColorScheme
              ),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: widget.username));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied Username')),
                );
              },
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 8.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary, // Set the primary color from ColorScheme
              ),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: widget.password));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied Password')),
                );
              },
              child: Icon(
                Icons.password,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
