//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FoldersApi {
  FoldersApi([ApiClient? apiClient])
      : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Creates a new folder.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [FoldersCreateRequestBody] foldersCreateRequestBody (required):
  Future<Response> foldersCreatePostWithHttpInfo(
    FoldersCreateRequestBody foldersCreateRequestBody,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/folders/create';

    // ignore: prefer_final_locals
    Object? postBody = foldersCreateRequestBody;

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

  /// Creates a new folder.
  ///
  /// Parameters:
  ///
  /// * [FoldersCreateRequestBody] foldersCreateRequestBody (required):
  Future<FoldersCreateResponseBody?> foldersCreatePost(
    FoldersCreateRequestBody foldersCreateRequestBody,
  ) async {
    final response = await foldersCreatePostWithHttpInfo(
      foldersCreateRequestBody,
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
        'FoldersCreateResponseBody',
      ) as FoldersCreateResponseBody;
    }
    return null;
  }

  /// Deletes an existing folder.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] folderUuid (required):
  ///
  /// * [bool] recursive (required):
  Future<Response> foldersDeleteDeleteWithHttpInfo(
    String folderUuid,
    bool recursive,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/folders/delete';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    queryParams.addAll(_queryParams('', 'folderUuid', folderUuid));
    queryParams.addAll(_queryParams('', 'recursive', recursive));

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

  /// Deletes an existing folder.
  ///
  /// Parameters:
  ///
  /// * [String] folderUuid (required):
  ///
  /// * [bool] recursive (required):
  Future<void> foldersDeleteDelete(
    String folderUuid,
    bool recursive,
  ) async {
    final response = await foldersDeleteDeleteWithHttpInfo(
      folderUuid,
      recursive,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Gets all folders for a user.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> foldersGetAllGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/folders/getAll';

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

  /// Gets all folders for a user.
  Future<FoldersGetAllResponseBody?> foldersGetAllGet() async {
    final response = await foldersGetAllGetWithHttpInfo();
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
        'FoldersGetAllResponseBody',
      ) as FoldersGetAllResponseBody;
    }
    return null;
  }

  /// Gets information on an existing folder.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] folderUuid (required):
  Future<Response> foldersGetGetWithHttpInfo(
    String folderUuid,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/folders/get';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    queryParams.addAll(_queryParams('', 'folderUuid', folderUuid));

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

  /// Gets information on an existing folder.
  ///
  /// Parameters:
  ///
  /// * [String] folderUuid (required):
  Future<FoldersGetResponseBody?> foldersGetGet(
    String folderUuid,
  ) async {
    final response = await foldersGetGetWithHttpInfo(
      folderUuid,
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
        'FoldersGetResponseBody',
      ) as FoldersGetResponseBody;
    }
    return null;
  }

  /// Updates an existing folder object.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [FoldersUpdateRequestBody] foldersUpdateRequestBody (required):
  Future<Response> foldersUpdatePutWithHttpInfo(
    FoldersUpdateRequestBody foldersUpdateRequestBody,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/folders/update';

    // ignore: prefer_final_locals
    Object? postBody = foldersUpdateRequestBody;

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

  /// Updates an existing folder object.
  ///
  /// Parameters:
  ///
  /// * [FoldersUpdateRequestBody] foldersUpdateRequestBody (required):
  Future<FoldersUpdateResponseBody?> foldersUpdatePut(
    FoldersUpdateRequestBody foldersUpdateRequestBody,
  ) async {
    final response = await foldersUpdatePutWithHttpInfo(
      foldersUpdateRequestBody,
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
        'FoldersUpdateResponseBody',
      ) as FoldersUpdateResponseBody;
    }
    return null;
  }
}
