import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/pages.dart';
import 'services.dart';
import '../shared/shared.dart';

class LoadFile {
  /// Wheter permission to save files to external storage is granted
  static Future<bool> _handlePermission() async {
    if (Platform.isIOS) return true;
    PermissionStatus permissionStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  /// Wheter file with same name as [filename] exists in [directory]
  static Future<bool> filenameExistsIn({
    Directory directory,
    List<FileInfo> fileInfos,
    List<String> filenames,
  }) async {
    bool exists = false;
    if (fileInfos == null) {
      var filesInDirectory = await directory.list().toList();
      for (int i = 0; i < filesInDirectory.length; i++) {
        String tempFilename = "";
        String path = filesInDirectory[i].path;
        for (int j = path.length - 1; j >= 0; j--) {
          if (path[j] == "/") break;
          tempFilename = path[j] + tempFilename;
        }
        filenames.forEach((v) {
          if (tempFilename == v) {
            exists = true;
          }
        });
        if (exists) return true;
      }
    } else {
      for (int i = 0; i < filenames.length; i++) {
        fileInfos.forEach((v) {
          if (filenames[i] == v.name) {
            exists = true;
          }
        });
        if (exists) return true;
      }
    }
    return false;
  }

  static Future<void> download(
    BuildContext context,
    String filePath,
    ConnectionPage currentConnectionPage, {
    bool ignoreExistingFiles = false,
  }) async {
    var model = Provider.of<ConnectionModel>(context);
    try {
      if (await _handlePermission()) {
        String filename = "";
        for (int i = 0; i < filePath.length; i++) {
          filename += filePath[i];
          if (filePath[i] == "/") {
            filename = "";
          }
        }
        Directory dir = await SettingsVariables.getDownloadDirectory();
        dir = await dir.create(recursive: true);
        bool exists = await filenameExistsIn(
          directory: dir,
          filenames: [filename],
        );
        if (!exists || ignoreExistingFiles) {
          await model.client
              .sftpDownload(
            path: filePath,
            toPath: dir.path,
            callback: (progress) {
              print(progress);
              model.progressValue = progress;
              model.showProgress = true;
              model.loadFilename = filename;
              model.progressType = "download";
            },
          )
              .then((String saveLocation) {
            _downloadCompleted(model, currentConnectionPage, saveLocation);
          });
        } else {
          customShowDialog(
              context: context,
              builder: (context) {
                return CustomAlertDialog(
                  title: Text(
                    "There is already a file with the same name. " +
                        "Replace $filename?",
                    style: TextStyle(fontFamily: "GoogleSans"),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      padding: EdgeInsets.only(
                        top: 8.5,
                        bottom: 8.0,
                        left: 14.0,
                        right: 14.0,
                      ),
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                      color: Theme.of(context).accentColor,
                      splashColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      padding: EdgeInsets.only(
                        top: 8.5,
                        bottom: 8.0,
                        left: 14.0,
                        right: 14.0,
                      ),
                      child: Text(
                        "OK",
                        style: TextStyle(
                          color:
                              Provider.of<CustomTheme>(context).isLightTheme()
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      elevation: .0,
                      onPressed: () {
                        download(
                          context,
                          filePath,
                          currentConnectionPage,
                          ignoreExistingFiles: true,
                        );
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: .0),
                  ],
                );
              });
        }
      }
    } catch (e) {
      print(e);
      currentConnectionPage.scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text("Download failed"),
        ),
      );
    }
  }

  static Future<void> upload(
    BuildContext context,
    ConnectionPage currentConnectionPage, {
    bool isReuploading = false,
    String pathFromReuploading,
  }) async {
    var model = Provider.of<ConnectionModel>(context);
    model.progressValue = 0;
    String path;
    if (!isReuploading) {
      try {
        path = await FilePicker.getFilePath();
      } catch (e) {
        print("Picking file failed");
      }
    } else {
      path = pathFromReuploading;
    }
    if (path == null) return;
    String filename = "";
    for (int i = 0; i < path.length; i++) {
      filename += path[i];
      if (path[i] == "/") {
        filename = "";
      }
    }
    var fileInfosMap =
        await model.client.sftpLs(currentConnectionPage.connection.path);
    List<FileInfo> fileInfos = [];
    fileInfosMap.forEach((v) => fileInfos.add(FileInfo.fromMap(v)));
    bool exists = await filenameExistsIn(
      fileInfos: fileInfos,
      filenames: [filename],
    );
    if (!exists || isReuploading) {
      try {
        model.client
            .sftpUpload(
          path: path,
          toPath: currentConnectionPage.connection.path,
          callback: (progress) {
            print(progress);
            model.progressValue = progress;
            model.showProgress = true;
            model.loadFilename = filename;
            model.progressType = "upload";
          },
        )
            .then((_) {
          _uploadCompleted(context, model, currentConnectionPage);
        });
      } catch (e) {
        print("Uploading failed");
      }
    } else {
      customShowDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: Text(
              "There is already a file with the same name. Replace $filename?",
              style: TextStyle(fontFamily: "GoogleSans"),
            ),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding: EdgeInsets.only(
                  top: 8.0,
                  bottom: 6.5,
                  left: 14.0,
                  right: 14.0,
                ),
                child: Row(
                  children: <Widget>[
                    Text("Cancel"),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                color: Theme.of(context).accentColor,
                splashColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding: EdgeInsets.only(
                  top: 8.0,
                  bottom: 6.5,
                  left: 14.0,
                  right: 14.0,
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      "OK",
                      style: TextStyle(
                        color: Provider.of<CustomTheme>(context).isLightTheme()
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                elevation: .0,
                onPressed: () {
                  upload(
                    context,
                    currentConnectionPage,
                    isReuploading: true,
                    pathFromReuploading: path,
                  );
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: .0),
            ],
          );
        },
      );
    }
  }

  static void _downloadCompleted(
    ConnectionModel model,
    ConnectionPage currentConnectionPage,
    String saveLocation,
  ) {
    model.showProgress = false;
    currentConnectionPage.scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 6),
        content: Text(
          "Download completed" +
              (Platform.isIOS ? "" : "\nSaved file to $saveLocation"),
        ),
        action: SnackBarAction(
          label: "Show file",
          textColor: Colors.white,
          onPressed: () async {
            if (Platform.isIOS) {
              await launch("shareddocuments://$saveLocation");
            } else {
              OpenFile.open(saveLocation);
            }
          },
        ),
      ),
    );
  }

  static void _uploadCompleted(
    BuildContext context,
    ConnectionModel model,
    ConnectionPage currentConnectionPage,
  ) {
    model.showProgress = false;
    currentConnectionPage.scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Upload completed"),
      ),
    );
    ConnectionMethods.refresh(context, currentConnectionPage.connection);
  }

  static Future<String> saveInCache(
    String filePath,
    ConnectionModel model,
  ) async {
    Directory cacheDir = await getTemporaryDirectory();
    await cacheDir.list().forEach((v) async {
      await v.delete();
    });
    String filename = "";
    for (int i = 0; i < filePath.length; i++) {
      filename += filePath[i];
      if (filePath[i] == "/") {
        filename = "";
      }
    }
    await model.client.sftpDownload(
      path: filePath,
      toPath: cacheDir.path,
      callback: (progress) {
        model.progressValue = progress;
        if (progress != 100) {
          model.showProgress = true;
          model.loadFilename = filename;
          model.progressType = "cache";
        } else if (progress == 100) {
          model.showProgress = false;
        }
      },
    );
    return cacheDir.path + "/" + filename;
  }
}
