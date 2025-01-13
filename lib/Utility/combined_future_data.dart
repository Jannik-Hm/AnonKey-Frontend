import 'package:anonkey_frontend/src/Credentials/credential_list.dart';
import 'package:anonkey_frontend/src/Folders/folder_list.dart';

class CombinedListData {
  final CredentialList? credentials;
  final FolderList? folders;

  CombinedListData({required this.credentials, required this.folders});
}
