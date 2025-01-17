import 'dart:async';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class ApiBaseData {
  static Future<String?> getURL() async {
    return await SharedPreferencesAsync().getString('url') ?? "";
  }

  static Future<void> setURL(String url) async {
    await SharedPreferencesAsync().setString('url', url);
  }

  static Future<bool?> lastCallSuccessful() async {
    return await SharedPreferencesAsync().getBool('lastapicallsuccess');
  }

  static Future<void> setlastCallSuccessful(bool boolean) async {
    await SharedPreferencesAsync().setBool('lastapicallsuccess', boolean);
  }

  static Future<T?> apiCallWrapper<T>(
    Future<T?> asyncFunction, {
    required String logMessage,
    Duration? timeout,
    bool returnNullOnTimeout = false,
  }) async {
    try {
      timeout ??= Duration(seconds: 5);
      T? result = await asyncFunction.timeout(timeout);
      return result;
    } catch (e) {
      if (e is TimeoutException) {
        log("TimeoutException: $logMessage");
        await setlastCallSuccessful(false);
        if (returnNullOnTimeout) {
          return null;
        }
      }
      rethrow;
    }
  }
}
