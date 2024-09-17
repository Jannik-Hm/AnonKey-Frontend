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
  var response = await http.get(
      Uri.parse("https://icons.duckduckgo.com/ip3/${_extractDomain(url)}.ico"));
  return response.bodyBytes;
}

const List<int> iconEmptyArray = [
  137,
  80,
  78,
  71,
  13,
  10,
  26,
  10,
  0,
  0,
  0,
  13,
  73,
  72,
  68,
  82,
  0,
  0,
  0,
  48,
  0,
  0,
  0,
  48,
  8,
  6,
  0,
  0,
  0,
  87,
  2,
  249,
  135,
  0,
  0,
  0,
  25,
  116,
  69,
  88,
  116,
  83,
  111,
  102,
  116,
  119,
  97,
  114,
  101,
  0,
  65,
  100,
  111,
  98,
  101,
  32,
  73,
  109,
  97,
  103,
  101,
  82,
  101,
  97,
  100,
  121,
  113,
  201,
  101,
  60,
  0,
  0,
  3,
  40,
  105,
  84,
  88,
  116,
  88,
  77,
  76,
  58,
  99,
  111,
  109,
  46,
  97,
  100,
  111,
  98,
  101,
  46,
  120,
  109,
  112,
  0,
  0,
  0,
  0,
  0,
  60,
  63,
  120,
  112,
  97,
  99,
  107,
  101,
  116,
  32,
  98,
  101,
  103,
  105,
  110,
  61,
  34,
  239,
  187,
  191,
  34,
  32,
  105,
  100,
  61,
  34,
  87,
  53,
  77,
  48,
  77,
  112,
  67,
  101,
  104,
  105,
  72,
  122,
  114,
  101,
  83,
  122,
  78,
  84,
  99,
  122,
  107,
  99,
  57,
  100,
  34,
  63,
  62,
  32,
  60,
  120,
  58,
  120,
  109,
  112,
  109,
  101,
  116,
  97,
  32,
  120,
  109,
  108,
  110,
  115,
  58,
  120,
  61,
  34,
  97,
  100,
  111,
  98,
  101,
  58,
  110,
  115,
  58,
  109,
  101,
  116,
  97,
  47,
  34,
  32,
  120,
  58,
  120,
  109,
  112,
  116,
  107,
  61,
  34,
  65,
  100,
  111,
  98,
  101,
  32,
  88,
  77,
  80,
  32,
  67,
  111,
  114,
  101,
  32,
  53,
  46,
  53,
  45,
  99,
  48,
  50,
  49,
  32,
  55,
  57,
  46,
  49,
  53,
  53,
  55,
  55,
  50,
  44,
  32,
  50,
  48,
  49,
  52,
  47,
  48,
  49,
  47,
  49,
  51,
  45,
  49,
  57,
  58,
  52,
  52,
  58,
  48,
  48,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  34,
  62,
  32,
  60,
  114,
  100,
  102,
  58,
  82,
  68,
  70,
  32,
  120,
  109,
  108,
  110,
  115,
  58,
  114,
  100,
  102,
  61,
  34,
  104,
  116,
  116,
  112,
  58,
  47,
  47,
  119,
  119,
  119,
  46,
  119,
  51,
  46,
  111,
  114,
  103,
  47,
  49,
  57,
  57,
  57,
  47,
  48,
  50,
  47,
  50,
  50,
  45,
  114,
  100,
  102,
  45,
  115,
  121,
  110,
  116,
  97,
  120,
  45,
  110,
  115,
  35,
  34,
  62,
  32,
  60,
  114,
  100,
  102,
  58,
  68,
  101,
  115,
  99,
  114,
  105,
  112,
  116,
  105,
  111,
  110,
  32,
  114,
  100,
  102,
  58,
  97,
  98,
  111,
  117,
  116,
  61,
  34,
  34,
  32,
  120,
  109,
  108,
  110,
  115,
  58,
  120,
  109,
  112,
  61,
  34,
  104,
  116,
  116,
  112,
  58,
  47,
  47,
  110,
  115,
  46,
  97,
  100,
  111,
  98,
  101,
  46,
  99,
  111,
  109,
  47,
  120,
  97,
  112,
  47,
  49,
  46,
  48,
  47,
  34,
  32,
  120,
  109,
  108,
  110,
  115,
  58,
  120,
  109,
  112,
  77,
  77,
  61,
  34,
  104,
  116,
  116,
  112,
  58,
  47,
  47,
  110,
  115,
  46,
  97,
  100,
  111,
  98,
  101,
  46,
  99,
  111,
  109,
  47,
  120,
  97,
  112,
  47,
  49,
  46,
  48,
  47,
  109,
  109,
  47,
  34,
  32,
  120,
  109,
  108,
  110,
  115,
  58,
  115,
  116,
  82,
  101,
  102,
  61,
  34,
  104,
  116,
  116,
  112,
  58,
  47,
  47,
  110,
  115,
  46,
  97,
  100,
  111,
  98,
  101,
  46,
  99,
  111,
  109,
  47,
  120,
  97,
  112,
  47,
  49,
  46,
  48,
  47,
  115,
  84,
  121,
  112,
  101,
  47,
  82,
  101,
  115,
  111,
  117,
  114,
  99,
  101,
  82,
  101,
  102,
  35,
  34,
  32,
  120,
  109,
  112,
  58,
  67,
  114,
  101,
  97,
  116,
  111,
  114,
  84,
  111,
  111,
  108,
  61,
  34,
  65,
  100,
  111,
  98,
  101,
  32,
  80,
  104,
  111,
  116,
  111,
  115,
  104,
  111,
  112,
  32,
  67,
  67,
  32,
  50,
  48,
  49,
  52,
  32,
  40,
  77,
  97,
  99,
  105,
  110,
  116,
  111,
  115,
  104,
  41,
  34,
  32,
  120,
  109,
  112,
  77,
  77,
  58,
  73,
  110,
  115,
  116,
  97,
  110,
  99,
  101,
  73,
  68,
  61,
  34,
  120,
  109,
  112,
  46,
  105,
  105,
  100,
  58,
  66,
  66,
  56,
  57,
  68,
  49,
  48,
  55,
  67,
  65,
  54,
  48,
  49,
  49,
  69,
  52,
  66,
  70,
  49,
  56,
  66,
  70,
  66,
  56,
  53,
  48,
  56,
  53,
  57,
  50,
  54,
  70,
  34,
  32,
  120,
  109,
  112,
  77,
  77,
  58,
  68,
  111,
  99,
  117,
  109,
  101,
  110,
  116,
  73,
  68,
  61,
  34,
  120,
  109,
  112,
  46,
  100,
  105,
  100,
  58,
  66,
  66,
  56,
  57,
  68,
  49,
  48,
  56,
  67,
  65,
  54,
  48,
  49,
  49,
  69,
  52,
  66,
  70,
  49,
  56,
  66,
  70,
  66,
  56,
  53,
  48,
  56,
  53,
  57,
  50,
  54,
  70,
  34,
  62,
  32,
  60,
  120,
  109,
  112,
  77,
  77,
  58,
  68,
  101,
  114,
  105,
  118,
  101,
  100,
  70,
  114,
  111,
  109,
  32,
  115,
  116,
  82,
  101,
  102,
  58,
  105,
  110,
  115,
  116,
  97,
  110,
  99,
  101,
  73,
  68,
  61,
  34,
  120,
  109,
  112,
  46,
  105,
  105,
  100,
  58,
  66,
  66,
  56,
  57,
  68,
  49,
  48,
  53,
  67,
  65,
  54,
  48,
  49,
  49,
  69,
  52,
  66,
  70,
  49,
  56,
  66,
  70,
  66,
  56,
  53,
  48,
  56,
  53,
  57,
  50,
  54,
  70,
  34,
  32,
  115,
  116,
  82,
  101,
  102,
  58,
  100,
  111,
  99,
  117,
  109,
  101,
  110,
  116,
  73,
  68,
  61,
  34,
  120,
  109,
  112,
  46,
  100,
  105,
  100,
  58,
  66,
  66,
  56,
  57,
  68,
  49,
  48,
  54,
  67,
  65,
  54,
  48,
  49,
  49,
  69,
  52,
  66,
  70,
  49,
  56,
  66,
  70,
  66,
  56,
  53,
  48,
  56,
  53,
  57,
  50,
  54,
  70,
  34,
  47,
  62,
  32,
  60,
  47,
  114,
  100,
  102,
  58,
  68,
  101,
  115,
  99,
  114,
  105,
  112,
  116,
  105,
  111,
  110,
  62,
  32,
  60,
  47,
  114,
  100,
  102,
  58,
  82,
  68,
  70,
  62,
  32,
  60,
  47,
  120,
  58,
  120,
  109,
  112,
  109,
  101,
  116,
  97,
  62,
  32,
  60,
  63,
  120,
  112,
  97,
  99,
  107,
  101,
  116,
  32,
  101,
  110,
  100,
  61,
  34,
  114,
  34,
  63,
  62,
  49,
  170,
  230,
  84,
  0,
  0,
  2,
  52,
  73,
  68,
  65,
  84,
  120,
  218,
  212,
  154,
  61,
  142,
  194,
  48,
  16,
  133,
  189,
  22,
  29,
  123,
  128,
  28,
  96,
  15,
  64,
  122,
  220,
  67,
  207,
  5,
  114,
  1,
  14,
  64,
  15,
  253,
  70,
  244,
  92,
  128,
  30,
  122,
  232,
  147,
  3,
  112,
  128,
  28,
  128,
  244,
  235,
  89,
  141,
  145,
  101,
  229,
  63,
  51,
  118,
  242,
  164,
  17,
  66,
  136,
  228,
  125,
  246,
  100,
  60,
  73,
  252,
  117,
  62,
  159,
  5,
  129,
  98,
  29,
  43,
  252,
  140,
  48,
  170,
  84,
  96,
  100,
  58,
  114,
  252,
  28,
  165,
  197,
  72,
  211,
  91,
  29,
  74,
  199,
  178,
  227,
  127,
  12,
  220,
  10,
  191,
  151,
  58,
  30,
  58,
  110,
  67,
  97,
  22,
  3,
  141,
  39,
  150,
  137,
  49,
  2,
  240,
  13,
  6,
  204,
  200,
  165,
  47,
  72,
  31,
  0,
  24,
  185,
  189,
  142,
  181,
  224,
  17,
  12,
  200,
  175,
  142,
  167,
  142,
  20,
  83,
  173,
  85,
  178,
  227,
  193,
  21,
  142,
  14,
  151,
  121,
  91,
  107,
  60,
  151,
  162,
  2,
  128,
  81,
  63,
  246,
  200,
  115,
  65,
  148,
  90,
  71,
  60,
  247,
  40,
  128,
  131,
  142,
  157,
  8,
  167,
  29,
  122,
  24,
  4,
  112,
  192,
  139,
  43,
  180,
  54,
  77,
  16,
  178,
  33,
  109,
  166,
  96,
  222,
  134,
  216,
  119,
  5,
  80,
  129,
  211,
  166,
  41,
  157,
  84,
  27,
  64,
  212,
  150,
  115,
  129,
  117,
  112,
  87,
  121,
  89,
  145,
  58,
  203,
  9,
  3,
  44,
  221,
  84,
  146,
  206,
  10,
  75,
  85,
  231,
  95,
  58,
  238,
  140,
  235,
  68,
  92,
  181,
  18,
  39,
  132,
  230,
  97,
  148,
  222,
  214,
  5,
  72,
  173,
  196,
  180,
  28,
  210,
  233,
  38,
  169,
  205,
  159,
  152,
  102,
  194,
  116,
  190,
  31,
  128,
  45,
  131,
  121,
  193,
  12,
  177,
  181,
  1,
  20,
  17,
  192,
  187,
  230,
  55,
  14,
  8,
  101,
  0,
  98,
  162,
  202,
  179,
  105,
  41,
  193,
  212,
  16,
  224,
  57,
  150,
  68,
  185,
  31,
  10,
  98,
  37,
  237,
  146,
  52,
  67,
  136,
  255,
  25,
  136,
  124,
  55,
  96,
  132,
  16,
  17,
  23,
  128,
  47,
  136,
  72,
  10,
  94,
  177,
  67,
  112,
  3,
  176,
  67,
  248,
  0,
  96,
  149,
  15,
  128,
  59,
  142,
  50,
  203,
  157,
  159,
  156,
  179,
  121,
  3,
  80,
  204,
  213,
  60,
  120,
  231,
  2,
  240,
  97,
  254,
  3,
  144,
  205,
  212,
  60,
  40,
  3,
  128,
  124,
  166,
  230,
  65,
  185,
  153,
  129,
  114,
  134,
  230,
  75,
  51,
  3,
  160,
  7,
  193,
  1,
  127,
  116,
  124,
  123,
  50,
  255,
  241,
  108,
  0,
  110,
  68,
  0,
  105,
  5,
  4,
  215,
  19,
  190,
  155,
  13,
  144,
  17,
  93,
  11,
  46,
  4,
  151,
  249,
  220,
  189,
  169,
  7,
  93,
  136,
  14,
  110,
  32,
  56,
  159,
  173,
  94,
  170,
  86,
  98,
  32,
  122,
  18,
  66,
  112,
  153,
  127,
  218,
  165,
  223,
  109,
  37,
  82,
  162,
  138,
  196,
  165,
  18,
  61,
  214,
  246,
  66,
  69,
  75,
  41,
  12,
  173,
  147,
  219,
  57,
  200,
  154,
  242,
  116,
  157,
  160,
  249,
  107,
  85,
  185,
  175,
  235,
  70,
  83,
  193,
  247,
  108,
  115,
  232,
  34,
  153,
  246,
  109,
  167,
  79,
  19,
  129,
  104,
  92,
  225,
  101,
  135,
  156,
  187,
  6,
  78,
  155,
  198,
  107,
  178,
  203,
  123,
  226,
  20,
  203,
  22,
  212,
  117,
  95,
  239,
  14,
  74,
  52,
  222,
  218,
  226,
  116,
  189,
  35,
  131,
  3,
  37,
  132,
  235,
  68,
  91,
  157,
  79,
  186,
  246,
  103,
  125,
  222,
  212,
  23,
  56,
  11,
  148,
  91,
  13,
  220,
  246,
  128,
  117,
  171,
  129,
  189,
  98,
  103,
  98,
  216,
  102,
  143,
  170,
  84,
  241,
  190,
  217,
  195,
  5,
  17,
  34,
  224,
  118,
  155,
  63,
  1,
  6,
  0,
  244,
  61,
  146,
  115,
  128,
  234,
  164,
  102,
  0,
  0,
  0,
  0,
  73,
  69,
  78,
  68,
  174,
  66,
  96,
  130
];

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
          return const Icon(Icons.public);
        } else if (snapshot.hasData) {
          return Image.network(snapshot.data!);
        } else {
          // Fallback if no data is present
          return const Icon(Icons.public);
        }
      });
}

StatefulWidget getByteLogoFromUrl(String url) {
  return FutureBuilder(
      future: _getBestLogoFromUrl(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is loading, show a progress indicator
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there's an error, show a fallback icon or error message
          // print(snapshot.error); // Debugging information
          return const Icon(Icons.public);
        } else if (snapshot.hasData &&
            !listEquals(iconEmptyArray, snapshot.data)) {
          // If data is available (URL of the image), show the image
          //print(snapshot.data); // Debugging information
          return Image.memory(snapshot.data!);
        } else {
          // Fallback if no data is present
          return const Icon(Icons.public);
        }
      });
}
