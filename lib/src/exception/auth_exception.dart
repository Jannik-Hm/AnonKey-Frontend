class NoCredentialException implements Exception {
  String errMsg() {
    return "No authentication data found";
  }
}

class NoTokensFoundException implements Exception {
  String errMsg() {
    return "No tokens found";
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  String errMsg() {
    return message;
  }
}
