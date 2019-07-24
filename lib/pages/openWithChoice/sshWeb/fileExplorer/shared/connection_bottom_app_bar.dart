import 'dart:io';

import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

import '../pages/pages.dart';
import '../services/services.dart';
import 'shared.dart';

class ConnectionBottomAppBar extends StatelessWidget {
  final ConnectionPage currentConnectionPage;
  final bool isPasteMode;
  final bool isCopyMode;
  final GestureTapCallback copy;
  final GestureTapCallback move;
  final GestureTapCallback paste;
  final GestureTapCallback cancelPasteMode;
  final bool isSelectionMode;
  final GestureTapCallback cancelSelection;
  final GestureTapCallback deleteSelectedFiles;
  final GestureTapCallback download;
  final bool downloadIsEnabled;
  final GestureTapCallback searchOnTap;

  ConnectionBottomAppBar({
    @required this.currentConnectionPage,
    @required this.isPasteMode,
    this.isCopyMode,
    this.copy,
    this.move,
    this.paste,
    this.cancelPasteMode,
    @required this.isSelectionMode,
    this.cancelSelection,
    this.deleteSelectedFiles,
    this.download,
    this.downloadIsEnabled = false,
    this.searchOnTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildIconButton({
      @required IconData iconData,
      @required String label,
      bool enabled = true,
      GestureTapCallback onTap,
    }) {
      return Opacity(
        opacity: enabled ? 1 : .42,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(iconData, size: 24),
                SizedBox(height: 4),
                Opacity(
                  opacity: enabled ? .86 : 1,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelectionMode || isPasteMode
                          ? Theme.of(context).accentIconTheme.color
                          : Theme.of(context).primaryIconTheme.color,
                    ),
                  ),
                ),
              ],
            ),
            Transform.scale(
              scale: 1.3,
              child: InkResponse(
                child: Container(
                  width: 80,
                  height: 80,
                ),
                onTap: enabled ? onTap : null,
              ),
            ),
          ],
        ),
      );
    }

    var model = Provider.of<ConnectionModel>(context);
    Widget loadProgressWidget = AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: model.showProgress ? 50 : 0,
      alignment: Alignment.topLeft,
      color: isSelectionMode || isPasteMode
          ? (Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.grey[800])
          : Theme.of(context).bottomAppBarColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 18.0, bottom: 12.0),
                  child: Text(
                    model.progressType == "download"
                        ? "Downloading ${model.loadFilename}"
                        : (model.progressType == "upload"
                            ? "Uploading ${model.loadFilename}"
                            : "Caching ${model.loadFilename}"),
                    style: TextStyle(
                      fontSize: 15.8,
                      fontWeight: FontWeight.w500,
                      color: Provider.of<CustomTheme>(context).isLightTheme()
                          ? Colors.grey[700]
                          : Colors.grey[200],
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 12.0),
                child: Text(
                  "${model.progressValue}%",
                  style: TextStyle(
                    fontSize: 15.8,
                    fontWeight: FontWeight.w500,
                    color: Provider.of<CustomTheme>(context).isLightTheme()
                        ? Colors.grey[700]
                        : Colors.grey[200],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3.0,
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                isSelectionMode || isPasteMode
                    ? (Theme.of(context).brightness == Brightness.light
                        ? Colors.grey[700]
                        : Colors.grey[200])
                    : Theme.of(context).accentColor,
              ),
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[300]
                  : Colors.grey[600],
              value: model.progressValue.toDouble() * .01,
            ),
          ),
        ],
      ),
    );

    List<Widget> selectionModeItems = [];
    selectionModeItems.add(
      buildIconButton(
        iconData: OMIcons.getApp,
        label: "Download",
        enabled: downloadIsEnabled,
        onTap: download,
      ),
    );
    selectionModeItems.add(
      buildIconButton(
        iconData: OMIcons.delete,
        label: "Delete",
        onTap: deleteSelectedFiles,
      ),
    );
    selectionModeItems.add(
      buildIconButton(
        iconData: OMIcons.fileCopy,
        label: "Copy to",
        onTap: copy,
      ),
    );
    selectionModeItems.add(
      buildIconButton(
        iconData: OMIcons.keyboardTab,
        label: "Move to",
        onTap: move,
      ),
    );
    selectionModeItems.add(
      buildIconButton(
        iconData: Icons.clear,
        label: "Cancel",
        onTap: cancelSelection,
      ),
    );

    List<Widget> pasteModeItems = [];
    pasteModeItems.add(
      buildIconButton(
        iconData: Icons.chevron_left,
        label: "Back",
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
    pasteModeItems.add(
      buildIconButton(
        iconData: OMIcons.forward,
        label: "Go to folder",
        onTap: () {
          customShowDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialog(
                title: Text(
                  "Go to folder",
                  style: TextStyle(fontSize: 18.0),
                ),
                content: Container(
                  width: 260.0,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Path",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
                          width: 2.0,
                        ),
                      ),
                    ),
                    cursorColor: Theme.of(context).accentColor,
                    autofocus: true,
                    autocorrect: false,
                    onSubmitted: (String value) {
                      Navigator.pop(context);
                      ConnectionMethods.goToDirectory(
                        context,
                        value,
                        currentConnectionPage.connection,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
    pasteModeItems.add(
      buildIconButton(
        iconData: Icons.search,
        label: "Search",
        onTap: searchOnTap,
      ),
    );
    pasteModeItems.add(
      buildIconButton(
        iconData: OMIcons.saveAlt,
        label: "Paste",
        onTap: paste,
      ),
    );
    pasteModeItems.add(
      buildIconButton(
        iconData: Icons.clear,
        label: "Cancel",
        onTap: cancelPasteMode,
      ),
    );

    List<Widget> items = [];
    items.add(
      buildIconButton(
        iconData: Icons.chevron_left,
        label: "Back",
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
    items.add(
      buildIconButton(
        iconData: OMIcons.forward,
        label: "Go to folder",
        onTap: () {
          customShowDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialog(
                title: Text(
                  "Go to folder",
                  style: TextStyle(fontSize: 18.0),
                ),
                content: Container(
                  width: 260.0,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Path",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
                          width: 2.0,
                        ),
                      ),
                    ),
                    cursorColor: Theme.of(context).accentColor,
                    autofocus: true,
                    autocorrect: false,
                    onSubmitted: (String value) {
                      Navigator.pop(context);
                      ConnectionMethods.goToDirectory(
                        context,
                        value,
                        currentConnectionPage.connection,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
    items.add(
      buildIconButton(
        iconData: Icons.search,
        label: "Search",
        onTap: searchOnTap,
      ),
    );
//    items.add(
//      buildIconButton(
//        iconData: OMIcons.settings,
//        label: "Settings",
//        onTap: () {
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (context) {
//                return SettingsPage(
//                  currentConnectionPage: currentConnectionPage,
//                );
//              },
//            ),
//          );
//        },
//      ),
//    );
    items.add(buildIconButton(
      iconData: Icons.info_outline,
      label: "Connection",
      onTap: () {
        ConnectionDialog(
          context: context,
          connection: currentConnectionPage.connection,
          isConnectionPage: true,
          primaryButtonIconData: Icons.remove_circle_outline,
          primaryButtonLabel: "Disconnect",
          primaryButtonOnPressed: () {
            //model.client.disconnectSFTP();
            //model.client.disconnect();
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ).show();
      },
    ));

    return BottomAppBar(
      child: Consumer<ConnectionModel>(
        builder: (context, model, child) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: (model.showProgress ? 50 : 0) + 65.0,
            child: Stack(
              alignment: Alignment.topLeft,
              children: <Widget>[
                loadProgressWidget,
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: 65,
                  margin: EdgeInsets.only(top: model.showProgress ? 50 : 0),
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: isSelectionMode
                            ? selectionModeItems
                            : (isPasteMode ? pasteModeItems : items),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
