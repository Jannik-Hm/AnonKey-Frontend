// import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

import 'package:image/image.dart' as imagelib;

import 'dart:typed_data';

Future<String?> _getBestLogoFromUrl(String url) async {
  // Get favicon
  //var faviconURL = (await _FaviconFinder.getBest(url))!.url;

  // Fetch the page's HTML
  var response = await http.get(Uri.parse("https://icons.duckduckgo.com/ip3/" + "google.de" + ".ico"), headers: {"Access-Control-Allow-Origin" : "*"});
  if (response.statusCode == 200) {
    var document = parser.parse(response.body);

    final faviconLink = document.querySelector('link[rel="icon"]')?.attributes['href'];
    // Find og:image
    var ogImageURL = document.querySelector('meta[property="og:image"]')?.attributes['content'];
    print(ogImageURL);
    // Compare and decide which is "best"
    if (ogImageURL != null) {
      print("test");
      // Return the og:image if available (assuming it's usually higher resolution)
      return ogImageURL;
    } else if (faviconLink != null) {
      print("test2");
      // If no og:image, return the favicon
      return faviconLink;
    }
  }

  // Return null if no logo found
  return null;
}

StatefulWidget getLogoFromUrl(String url) {
  return FutureBuilder(
      future: _getBestLogoFromUrl(url),
      builder: (context, snapshot) {
        /* if(snapshot.hasData && snapshot.data != null){
      print(snapshot.hasData);
      print(snapshot.data);
      return Image.network(snapshot.data!);
    }else{
      return const Icon(Icons.public);
    } */
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is loading, show a progress indicator
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there's an error, show a fallback icon or error message
          // print(snapshot.error); // Debugging information
          print(snapshot.error);
          return const Icon(Icons.public);
        } else if (snapshot.hasData) {
          // If data is available (URL of the image), show the image
          return Image.network(snapshot.data!);
        } else {
          // Fallback if no data is present
          return const Icon(Icons.public);
        }
      });
}

// Signatures from https://en.wikipedia.org/wiki/List_of_file_signatures
const ICO_SIG = [0, 0, 1, 0];
const PNG_SIG = [137, 80, 78, 71, 13, 10, 26, 10];

class _Favicon implements Comparable<_Favicon> {
  String url;
  int width;
  int height;

  _Favicon(this.url, {this.width = 0, this.height = 0});

  @override
  int compareTo(_Favicon other) {
    // If both are vector graphics, use URL length as tie-breaker
    if (url.endsWith('.svg') && other.url.endsWith('.svg')) {
      return url.length < other.url.length ? -1 : 1;
    }

    // Sort vector graphics before bitmaps
    if (url.endsWith('.svg')) return -1;
    if (other.url.endsWith('.svg')) return 1;

    // If bitmap size is the same, use URL length as tie-breaker
    if (width * height == other.width * other.height) {
      return url.length < other.url.length ? -1 : 1;
    }

    // Sort on bitmap size
    return (width * height > other.width * other.height) ? -1 : 1;
  }

  @override
  String toString() {
    return '{Url: $url, width: $width, height: $height}';
  }
}

class _FaviconFinder {
  static Future<List<_Favicon>> getAll(
    String url, {
    List<String>? suffixes,
  }) async {
    var favicons = <_Favicon>[];
    var iconUrls = <String>[];

    var uri = Uri.parse(url);
    var document = parser.parse((await http.get(uri, headers: {"Access-Control-Allow-Origin": "*"})).body);

    // Look for icons in tags
    for (var rel in ['icon', 'shortcut icon']) {
      for (var iconTag in document.querySelectorAll("link[rel='$rel']")) {
        if (iconTag.attributes['href'] != null) {
          var iconUrl = iconTag.attributes['href']!.trim();

          // Fix scheme relative URLs
          if (iconUrl.startsWith('//')) {
            iconUrl = uri.scheme + ':' + iconUrl;
          }

          // Fix relative URLs
          if (iconUrl.startsWith('/')) {
            iconUrl = uri.scheme + '://' + uri.host + iconUrl;
          }

          // Fix naked URLs
          if (!iconUrl.startsWith('http')) {
            iconUrl = uri.scheme + '://' + uri.host + '/' + iconUrl;
          }

          // Remove query strings
          iconUrl = iconUrl.split('?').first;

          // Verify so the icon actually exists
          if (await _verifyImage(iconUrl)) {
            iconUrls.add(iconUrl);
          }
        }
      }
    }

    // Look for icon by predefined URL
    var iconUrl = uri.scheme + '://' + uri.host + '/favicon.ico';
    if (await _verifyImage(iconUrl)) {
      iconUrls.add(iconUrl);
    }

    // Deduplicate
    iconUrls = iconUrls.toSet().toList();

    // Filter on suffixes
    if (suffixes != null) {
      iconUrls.removeWhere((url) => !suffixes.contains(url.split('.').last));
    }

    // Fetch dimensions
    for (var iconUrl in iconUrls) {
      // No need for size calculation on vector images
      if (iconUrl.endsWith('.svg')) {
        favicons.add(_Favicon(iconUrl));
        continue;
      }

      // Image library lacks read support for Ico, assume standard size
      // https://github.com/brendan-duncan/image/issues/212
      if (iconUrl.endsWith('.ico')) {
        favicons.add(_Favicon(iconUrl, width: 16, height: 16));
        continue;
      }

      var image = imagelib.decodeImage((await http.get(Uri.parse(iconUrl), headers: {"Access-Control-Allow-Origin": "*"})).bodyBytes);
      if (image != null) {
        favicons
            .add(_Favicon(iconUrl, width: image.width, height: image.height));
      }
    }

    return favicons..sort();
  }

  static Future<_Favicon?> getBest(String url, {List<String>? suffixes}) async {
    List<_Favicon> favicons = await getAll(url, suffixes: suffixes);
    return favicons.isNotEmpty ? favicons.first : null;
  }

  static Future<bool> _verifyImage(String url) async {
    var response = await http.get(Uri.parse(url), headers: {"Access-Control-Allow-Origin": "*"});

    var contentType = response.headers['content-type'];
    if (contentType == null || !contentType.contains('image')) return false;

    // Take extra care with ico's since they might be constructed manually
    if (url.endsWith('.ico')) {
      if (response.bodyBytes.length < 4) return false;

      // Check if ico file contains a valid image signature
      if (!_verifySignature(response.bodyBytes, ICO_SIG) &&
          !_verifySignature(response.bodyBytes, PNG_SIG)) {
        return false;
      }
    }

    return response.statusCode == 200 &&
        (response.contentLength ?? 0) > 0 &&
        contentType.contains('image');
  }

  static bool _verifySignature(Uint8List bodyBytes, List<int> signature) {
    var fileSignature = bodyBytes.sublist(0, signature.length);
    for (var i = 0; i < fileSignature.length; i++) {
      if (fileSignature[i] != signature[i]) return false;
    }
    return true;
  }
}
