import 'dart:convert';

import 'package:flutter/material.dart';

class NotificationPopup {
  static void apiError(
      {required BuildContext context, String? apiResponseMessage}) {
    String message = (apiResponseMessage?.isNotEmpty ?? false)
        ? jsonDecode(apiResponseMessage!)["detail"]
        : "API Error. Please try again.\nIf error stays, please log out and back in.";
    popupErrorMessage(context: context, message: message);
  }

  static void popupErrorMessage(
      {required BuildContext context, required String message}) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }
}
