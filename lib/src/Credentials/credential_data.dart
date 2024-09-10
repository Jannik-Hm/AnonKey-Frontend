class Credential {
  final String uuid;
  String password;
  String passwordSalt;
  String username;
  String usernameSalt;
  String websiteUrl;
  String note;
  String displayName;
  String folderUuid;
  String createdTimeStamp;
  String changedTimeStamp;
  String deletedTimeStamp;

  Credential({
    required this.websiteUrl,
    required this.username,
    required this.password,
    required this.displayName,
    required this.uuid,
    required this.passwordSalt,
    required this.usernameSalt,
    required this.note,
    required this.folderUuid,
    required this.createdTimeStamp,
    required this.changedTimeStamp,
    required this.deletedTimeStamp,
  });
}