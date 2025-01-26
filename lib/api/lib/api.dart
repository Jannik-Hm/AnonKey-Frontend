//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

library openapi.api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'api/authentication_api.dart';
part 'api/credentials_api.dart';
part 'api/folders_api.dart';
part 'api/service_api.dart';
part 'api/users_api.dart';
part 'api/uuid_api.dart';
part 'api_client.dart';
part 'api_exception.dart';
part 'api_helper.dart';
part 'auth/api_key_auth.dart';
part 'auth/authentication.dart';
part 'auth/http_basic_auth.dart';
part 'auth/http_bearer_auth.dart';
part 'auth/oauth.dart';
part 'model/authentication_change_password_request_body.dart';
part 'model/authentication_login_request_body.dart';
part 'model/authentication_login_response_body.dart';
part 'model/authentication_login_token.dart';
part 'model/authentication_refresh_access_token.dart';
part 'model/authentication_refresh_access_token_response_body.dart';
part 'model/credentials_create_credential.dart';
part 'model/credentials_create_request_body.dart';
part 'model/credentials_get_all_credential.dart';
part 'model/credentials_get_all_response_body.dart';
part 'model/credentials_get_credential.dart';
part 'model/credentials_get_response_body.dart';
part 'model/credentials_update_credential_request.dart';
part 'model/credentials_update_credential_response.dart';
part 'model/credentials_update_request_body.dart';
part 'model/credentials_update_response_body.dart';
part 'model/error_response_body.dart';
part 'model/folders_create_folder.dart';
part 'model/folders_create_request_body.dart';
part 'model/folders_create_response_body.dart';
part 'model/folders_get_all_folder.dart';
part 'model/folders_get_all_response_body.dart';
part 'model/folders_get_folder.dart';
part 'model/folders_get_response_body.dart';
part 'model/folders_update_folder.dart';
part 'model/folders_update_request_body.dart';
part 'model/folders_update_response_body.dart';
part 'model/users_create_request_body.dart';
part 'model/users_create_response_body.dart';
part 'model/users_create_response_token.dart';
part 'model/users_get_response_body.dart';
part 'model/users_get_user.dart';
part 'model/users_update_request_body.dart';
part 'model/users_update_user.dart';

/// An [ApiClient] instance that uses the default values obtained from
/// the OpenAPI specification file.
var defaultApiClient = ApiClient();

const _delimiters = {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};
const _dateEpochMarker = 'epoch';
const _deepEquality = DeepCollectionEquality();
final _dateFormatter = DateFormat('yyyy-MM-dd');
final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

bool _isEpochMarker(String? pattern) =>
    pattern == _dateEpochMarker || pattern == '/$_dateEpochMarker/';
