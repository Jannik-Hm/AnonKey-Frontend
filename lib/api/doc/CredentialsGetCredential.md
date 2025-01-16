# anonkey_frontend.model.CredentialsGetCredential

## Load the model package
```dart
import 'package:anonkey_frontend/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**uuid** | **String** | The UUID of the credential. | [optional] 
**password** | **String** | The encrypted password to store. | [optional] 
**passwordSalt** | **String** | The salt of the stored password. | [optional] 
**username** | **String** | The encrypted username to store. | [optional] 
**usernameSalt** | **String** | The salt of the encrypted username. | [optional] 
**websiteUrl** | **String** | The URL of the website the credential belongs to. | [optional] 
**websiteUrlSalt** | **String** | The WebsiteUrlSalt of the credetial | [optional] 
**note** | **String** | A note attached to the credential. | [optional] 
**noteSalt** | **String** | The NoteSalt  of the credetial | [optional] 
**displayName** | **String** | The display name of the credential.. | [optional] 
**displayNameSalt** | **String** | The DisplayNameSalt of the credetial | [optional] 
**folderUuid** | **String** | The UUID of the folder the credential is in.  Use NULL for no folder. | [optional] 
**createdTimestamp** | **int** | The unix timestamp at which the credential was created. | [optional] 
**changedTimestamp** | **int** | The unix timestamp at which the credential was last edited. | [optional] 
**deletedTimestamp** | **int** | The unix timestamp the credential was deleted at. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


