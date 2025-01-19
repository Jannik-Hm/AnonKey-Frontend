import 'dart:async';
import 'dart:developer';

import 'package:anonkey_frontend/Utility/notification_popup.dart';
import 'package:anonkey_frontend/src/exception/missing_build_context_exception.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnonKeyServerOffline implements Exception {
  String? message;
  AnonKeyServerOffline(this.message);
}

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
    timeout ??= Duration(milliseconds: 5);
    try {
      await setlastCallSuccessful(true);
      T? result = await asyncFunction.timeout(timeout);
      return result;
    } catch (e) {
      if (e is TimeoutException) {
        log("TimeoutException: $logMessage");
        await setlastCallSuccessful(false);
        if (returnNullOnTimeout) {
          return null;
        } else {
          throw AnonKeyServerOffline(logMessage);
        }
      }
      rethrow;
    }
  }

  static void callFuncIfServerReachable(
    void Function() func, {
    required BuildContext context,
    String offlineErrorMessage =
        "This option is disabled as you seem to be offline. Refresh to enable this feature again.",
  }) {
    lastCallSuccessful().then(
      (lastapicallsuccess) {
        if (lastapicallsuccess ?? false) {
          func();
        } else {
          if (context.mounted) {
            NotificationPopup.popupErrorMessage(
              context: context,
              message: offlineErrorMessage,
            );
          } else {
            throw MissingBuildContextException();
          }
        }
      },
    );
  }

  static Future<void Function()?> aCallFuncIfServerReachable(
    void Function() func, {
    required BuildContext context,
    String offlineErrorMessage =
        "This option is disabled as you seem to be offline. Refresh to enable this feature again.",
  }) async {
    bool lastapicallsuccess = await lastCallSuccessful() ?? false;
    if (lastapicallsuccess) {
      return func;
    } else {
      if (context.mounted) {
        return (() {
          NotificationPopup.popupErrorMessage(
            context: context,
            message: offlineErrorMessage,
          );
        });
      } else {
        throw MissingBuildContextException();
      }
    }
  }
}
