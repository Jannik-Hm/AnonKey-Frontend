//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CredentialsApi {
  CredentialsApi([ApiClient? apiClient])
      : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Creates a new credential object.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CredentialsCreateRequestBody] credentialsCreateRequestBody (required):
  Future<Response> credentialsCreatePostWithHttpInfo(
    CredentialsCreateRequestBody credentialsCreateRequestBody,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/credentials/create';

    // ignore: prefer_final_locals
    Object? postBody = credentialsCreateRequestBody;

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

  /// Creates a new credential object.
  ///
  /// Parameters:
  ///
  /// * [CredentialsCreateRequestBody] credentialsCreateRequestBody (required):
  Future<void> credentialsCreatePost(
    CredentialsCreateRequestBody credentialsCreateRequestBody,
  ) async {
    final response = await credentialsCreatePostWithHttpInfo(
      credentialsCreateRequestBody,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Deletes an existing credential object.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] credentialUuid (required):
  Future<Response> credentialsDeleteDeleteWithHttpInfo(
    String credentialUuid,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/credentials/delete';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    queryParams.addAll(_queryParams('', 'credentialUuid', credentialUuid));

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

  /// Deletes an existing credential object.
  ///
  /// Parameters:
  ///
  /// * [String] credentialUuid (required):
  Future<void> credentialsDeleteDelete(
    String credentialUuid,
  ) async {
    final response = await credentialsDeleteDeleteWithHttpInfo(
      credentialUuid,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Gets all available credential objects for this user.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> credentialsGetAllGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/credentials/getAll';

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

  /// Gets all available credential objects for this user.
  Future<CredentialsGetAllResponseBody?> credentialsGetAllGet() async {
    final response = await credentialsGetAllGetWithHttpInfo();
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
        'CredentialsGetAllResponseBody',
      ) as CredentialsGetAllResponseBody;
    }
    return null;
  }

  /// Gets information on a credential object.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] credentialUuid (required):
  Future<Response> credentialsGetGetWithHttpInfo(
    String credentialUuid,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/credentials/get';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    queryParams.addAll(_queryParams('', 'credentialUuid', credentialUuid));

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

  /// Gets information on a credential object.
  ///
  /// Parameters:
  ///
  /// * [String] credentialUuid (required):
  Future<CredentialsGetResponseBody?> credentialsGetGet(
    String credentialUuid,
  ) async {
    final response = await credentialsGetGetWithHttpInfo(
      credentialUuid,
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
        'CredentialsGetResponseBody',
      ) as CredentialsGetResponseBody;
    }
    return null;
  }

  /// SoftDeletes an existing credential object.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] credentialUuid (required):
  Future<Response> credentialsSoftDeletePutWithHttpInfo(
    String credentialUuid,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/credentials/soft-delete';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    queryParams.addAll(_queryParams('', 'credentialUuid', credentialUuid));

    const contentTypes = <String>[];

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

  /// SoftDeletes an existing credential object.
  ///
  /// Parameters:
  ///
  /// * [String] credentialUuid (required):
  Future<void> credentialsSoftDeletePut(
    String credentialUuid,
  ) async {
    final response = await credentialsSoftDeletePutWithHttpInfo(
      credentialUuid,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// SoftUndeletes an existing credential object.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] credentialUuid (required):
  Future<Response> credentialsSoftUndeletePutWithHttpInfo(
    String credentialUuid,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/credentials/soft-undelete';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    queryParams.addAll(_queryParams('', 'credentialUuid', credentialUuid));

    const contentTypes = <String>[];

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

  /// SoftUndeletes an existing credential object.
  ///
  /// Parameters:
  ///
  /// * [String] credentialUuid (required):
  Future<void> credentialsSoftUndeletePut(
    String credentialUuid,
  ) async {
    final response = await credentialsSoftUndeletePutWithHttpInfo(
      credentialUuid,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Updates a credential object.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CredentialsUpdateRequestBody] credentialsUpdateRequestBody (required):
  Future<Response> credentialsUpdatePutWithHttpInfo(
    CredentialsUpdateRequestBody credentialsUpdateRequestBody,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/credentials/update';

    // ignore: prefer_final_locals
    Object? postBody = credentialsUpdateRequestBody;

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

  /// Updates a credential object.
  ///
  /// Parameters:
  ///
  /// * [CredentialsUpdateRequestBody] credentialsUpdateRequestBody (required):
  Future<CredentialsUpdateResponseBody?> credentialsUpdatePut(
    CredentialsUpdateRequestBody credentialsUpdateRequestBody,
  ) async {
    final response = await credentialsUpdatePutWithHttpInfo(
      credentialsUpdateRequestBody,
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
        'CredentialsUpdateResponseBody',
      ) as CredentialsUpdateResponseBody;
    }
    return null;
  }
}
