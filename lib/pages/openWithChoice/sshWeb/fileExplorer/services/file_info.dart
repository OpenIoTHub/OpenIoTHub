class FileInfo {
  String name;
  String modificationDate;
  String lastAccess;
  bool isDirectory;
  String permissions;
  int ownerUserId;
  int ownerGroupId;
  int flags;
  int size;
  String convertedSize;

  FileInfo({
    this.name,
    this.modificationDate,
    this.lastAccess,
    this.isDirectory,
    this.permissions,
    this.ownerUserId,
    this.ownerGroupId,
    this.flags,
    this.size,
    this.convertedSize,
  });

  factory FileInfo.fromMap(Map<String, dynamic> map) {
    return FileInfo(
      name: map["filename"],
      modificationDate: map["modificationDate"],
      lastAccess: map["lastAccess"],
      isDirectory: map["isDirectory"],
      permissions: map["permissions"],
      ownerUserId: map["ownerUserID"],
      ownerGroupId: map["ownerGroupID"],
      flags: map["flags"],
      size: map["fileSize"],
      convertedSize: map["convertedFileSize"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "modificationDate": modificationDate,
      "lastAccess": lastAccess,
      "isDirectory": isDirectory,
      "permissions": permissions,
      "ownerUserId": ownerUserId,
      "ownerGroupId": ownerGroupId,
      "flags": flags,
      "size": size,
      "convertedSize": convertedSize,
    };
  }

  FileInfo copyWith(FileInfo fileInfo) {
    return FileInfo(
      name: fileInfo.name ?? name,
      modificationDate: fileInfo.modificationDate ?? modificationDate,
      lastAccess: fileInfo.lastAccess ?? lastAccess,
      isDirectory: fileInfo.isDirectory ?? isDirectory,
      permissions: fileInfo.permissions ?? permissions,
      ownerUserId: fileInfo.ownerUserId ?? ownerUserId,
      ownerGroupId: fileInfo.ownerGroupId ?? ownerGroupId,
      flags: fileInfo.flags ?? flags,
      size: fileInfo.size ?? size,
      convertedSize: fileInfo.convertedSize ?? convertedSize,
    );
  }
}
