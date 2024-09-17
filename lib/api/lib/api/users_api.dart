//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UsersApi {
  UsersApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Creates a new user.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [UsersCreateRequestBody] usersCreateRequestBody (required):
  Future<Response> userCreatePostWithHttpInfo(
    UsersCreateRequestBody usersCreateRequestBody,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/user/create';

    // ignore: prefer_final_locals
    Object? postBody = usersCreateRequestBody;

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

  /// Creates a new user.
  ///
  /// Parameters:
  ///
  /// * [UsersCreateRequestBody] usersCreateRequestBody (required):
  Future<UsersCreateResponseBody?> userCreatePost(
    UsersCreateRequestBody usersCreateRequestBody,
  ) async {
    final response = await userCreatePostWithHttpInfo(
      usersCreateRequestBody,
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
        'UsersCreateResponseBody',
      ) as UsersCreateResponseBody;
    }
    return null;
  }

  /// Deletes an existing user.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> userDeleteDeleteWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/user/delete';

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

  /// Deletes an existing user.
  Future<void> userDeleteDelete() async {
    final response = await userDeleteDeleteWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Gets information for an existing user.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> userGetGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/user/get';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Gets information for an existing user.
  Future<UsersGetResponseBody?> userGetGet() async {
    final response = await userGetGetWithHttpInfo();
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
        'UsersGetResponseBody',
      ) as UsersGetResponseBody;
    }
    return null;
  }

  /// Updates an existing user.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [UsersUpdateRequestBody] usersUpdateRequestBody (required):
  Future<Response> userUpdatePutWithHttpInfo(
    UsersUpdateRequestBody usersUpdateRequestBody,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/user/update';

    // ignore: prefer_final_locals
    Object? postBody = usersUpdateRequestBody;

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

  /// Updates an existing user.
  ///
  /// Parameters:
  ///
  /// * [UsersUpdateRequestBody] usersUpdateRequestBody (required):
  Future<void> userUpdatePut(
    UsersUpdateRequestBody usersUpdateRequestBody,
  ) async {
    final response = await userUpdatePutWithHttpInfo(
      usersUpdateRequestBody,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
