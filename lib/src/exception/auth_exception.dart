class NoCredentialException implements Exception {
  String errMsg() {
    return "No authentication data found";
  }
}