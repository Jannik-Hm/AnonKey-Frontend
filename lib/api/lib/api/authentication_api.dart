//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AuthenticationApi {
  AuthenticationApi([ApiClient? apiClient])
      : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Changes a users password.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AuthenticationChangePasswordRequestBody] authenticationChangePasswordRequestBody (required):
  Future<Response> authenticationChangePasswordPutWithHttpInfo(
    AuthenticationChangePasswordRequestBody
        authenticationChangePasswordRequestBody,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/authentication/changePassword';

    // ignore: prefer_final_locals
    Object? postBody = authenticationChangePasswordRequestBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Changes a users password.
  ///
  /// Parameters:
  ///
  /// * [AuthenticationChangePasswordRequestBody] authenticationChangePasswordRequestBody (required):
  Future<void> authenticationChangePasswordPut(
    AuthenticationChangePasswordRequestBody
        authenticationChangePasswordRequestBody,
  ) async {
    final response = await authenticationChangePasswordPutWithHttpInfo(
      authenticationChangePasswordRequestBody,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Authenticates the user and returns an access token.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AuthenticationLoginRequestBody] authenticationLoginRequestBody (required):
  Future<Response> authenticationLoginPostWithHttpInfo(
    AuthenticationLoginRequestBody authenticationLoginRequestBody,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/authentication/login';

    // ignore: prefer_final_locals
    Object? postBody = authenticationLoginRequestBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Authenticates the user and returns an access token.
  ///
  /// Parameters:
  ///
  /// * [AuthenticationLoginRequestBody] authenticationLoginRequestBody (required):
  Future<AuthenticationLoginResponseBody?> authenticationLoginPost(
    AuthenticationLoginRequestBody authenticationLoginRequestBody,
  ) async {
    final response = await authenticationLoginPostWithHttpInfo(
      authenticationLoginRequestBody,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'AuthenticationLoginResponseBody',
      ) as AuthenticationLoginResponseBody;
    }
    return null;
  }

  /// Invalidates an access token for user logout.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> authenticationLogoutDeleteWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/authentication/logout';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Invalidates an access token for user logout.
  Future<void> authenticationLogoutDelete() async {
    final response = await authenticationLogoutDeleteWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
