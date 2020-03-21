import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

import '../pages/pages.dart';
import '../services/services.dart';
import 'shared.dart';

class FileBottomSheet extends StatelessWidget {
  final BuildContext context;
  final FileInfo fileInfo;
  final ConnectionPage current;

  FileBottomSheet(this.context, this.fileInfo, this.current);

  void show() {
    showModalBottomSheet(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    String filePath = current.connection.path + "/" + fileInfo.name;

    double tableFontSize = 16.0;
    var renameController = TextEditingController(text: fileInfo.name);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 56.0,
                child: ListTile(
                  leading: Icon(fileInfo.isDirectory
                      ? Icons.folder_open
                      : Icons.insert_drive_file),
                  title: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Text(
                        fileInfo.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 1.0,
                color: Theme.of(context).dividerColor,
              ),
              Consumer<ConnectionModel>(builder: (context, model, child) {
                return Container(
                  height: constraints.maxHeight - 57.0,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Opacity(
                          opacity: .8,
                          child: Table(
                            columnWidths: {0: FixedColumnWidth(158.0)},
                            children: <TableRow>[
//                              if (!fileInfo.isDirectory)
//                                TableRow(children: [
//                                  Padding(
//                                    padding: EdgeInsets.only(bottom: 2.0),
//                                    child: Text(
//                                      "Size:",
//                                      style: TextStyle(fontSize: tableFontSize),
//                                    ),
//                                  ),
//                                  Text(
//                                    fileInfo.convertedSize,
//                                    style: TextStyle(fontSize: tableFontSize),
//                                  ),
//                                ]),
                              TableRow(children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 2.0),
                                  child: Text(
                                    "Permissions:",
                                    style: TextStyle(fontSize: tableFontSize),
                                  ),
                                ),
                                Text(
                                  fileInfo.permissions,
                                  style: TextStyle(fontSize: tableFontSize),
                                ),
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 2.0),
                                  child: Text(
                                    "Modification Date:",
                                    style: TextStyle(fontSize: tableFontSize),
                                  ),
                                ),
                                Text(
                                  fileInfo.modificationDate,
                                  style: TextStyle(fontSize: tableFontSize),
                                ),
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 2.0),
                                  child: Text(
                                    "Last Access:",
                                    style: TextStyle(fontSize: tableFontSize),
                                  ),
                                ),
                                Text(
                                  fileInfo.lastAccess,
                                  style: TextStyle(fontSize: tableFontSize),
                                ),
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 2.0),
                                  child: Text(
                                    "Path:",
                                    style: TextStyle(fontSize: tableFontSize),
                                  ),
                                ),
                                Text(
                                  current.connection.path + "/" + fileInfo.name,
                                  style: TextStyle(fontSize: tableFontSize),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 1.0,
                        margin: EdgeInsets.only(bottom: 8.0),
                        color: Theme.of(context).dividerColor,
                      ),
                      fileInfo.isDirectory
                          ? Container()
                          : ListTile(
                              leading: Icon(
                                Icons.open_in_new,
                                color: Theme.of(context).accentColor,
                              ),
                              title: Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Text(
                                  "Open",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              onTap: () async {
                                Navigator.pop(context);
                                OpenFile.open(
                                  await LoadFile.saveInCache(filePath, model),
                                );
                              },
                            ),
                      fileInfo.isDirectory
                          ? Container()
                          : Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(
                                    OMIcons.getApp,
                                    color: Theme.of(context).accentColor,
                                    size: 27,
                                  ),
                                  title: Padding(
                                    padding: EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      "Download",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    await LoadFile.download(
                                      context,
                                      filePath,
                                      current,
                                    );
                                  },
                                ),
                              ],
                            ),
                      ListTile(
                        leading: Icon(
                          OMIcons.edit,
                          color: Theme.of(context).accentColor,
                        ),
                        title: Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Text(
                            "Rename",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        onTap: () {
                          customShowDialog(
                            context: context,
                            builder: (context) {
                              return CustomAlertDialog(
                                title: Text("重新命名 '${fileInfo.name}'"),
                                content: TextField(
                                  controller: renameController,
                                  decoration: InputDecoration(
                                    labelText: "新名称",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  cursorColor: Theme.of(context).accentColor,
                                  autofocus: true,
                                  onSubmitted: (String value) async {
                                    String newFilePath =
                                        current.connection.path + "/" + value;
                                    await model.client.sftpRename(
                                      oldPath: filePath,
                                      newPath: newFilePath,
                                    );
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    ConnectionMethods.refresh(
                                        context, current.connection);
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(OMIcons.delete,
                            color: Theme.of(context).accentColor),
                        title: Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Text(
                            "Delete",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        onTap: () {
                          ConnectionMethods.showDeleteConfirmDialog(
                            context: context,
                            filePaths: [filePath],
                            isDirectory: [fileInfo.isDirectory],
                            currentConnection: current.connection,
                            calledFromFileBottomSheet: true,
                          );
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
