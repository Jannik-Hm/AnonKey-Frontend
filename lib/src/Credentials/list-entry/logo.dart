import 'package:favicon/favicon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String _extractDomain(String url) {
  // Parse the URL using Uri.parse
  Uri parsedUrl = Uri.parse(url);

  // Extract the host (domain) from the parsed URL
  String domain = parsedUrl.host;

  // Optionally remove 'www.' if it exists
  if (domain.startsWith('www.')) {
    domain = domain.substring(4);
  }

  return domain;
}

Future<String?> _getBestLogoUrlFromUrl(String url) async {
  // Get favicon
  var faviconURL = (await FaviconFinder.getBest(url))!.url;
  return faviconURL;
}

//TODO: Backend API to Scan for favicons to prevent CORS error
Future<Uint8List> _getBestLogoFromUrl(String url) async {
  var response = await http.get(Uri.parse("https://icons.duckduckgo.com/ip3/${_extractDomain(url)}.ico"));
  return response.bodyBytes;
}

StatefulWidget getNetworkLogoFromUrl(String url) {
  return FutureBuilder(
      future: _getBestLogoUrlFromUrl(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is loading, show a progress indicator
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there's an error, show a fallback icon or error message
          // print(snapshot.error); // Debugging information
          return Icon(
            Icons.public,
            color: Theme.of(context).colorScheme.onTertiary,
          );
        } else if (snapshot.hasData) {
          return Image.network(snapshot.data!);
        } else {
          // Fallback if no data is present
          return Icon(
            Icons.public,
            color: Theme.of(context).colorScheme.onTertiary,
          );
        }
      });
}
