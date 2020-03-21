import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared/shared.dart';
import '../services/services.dart';
import 'shared.dart';

class ConnectionWidgetTile extends StatefulWidget {
  final int index;
  final List<FileInfo> fileInfos;
  final bool isLoading;
  final bool isSelected;
  final bool isSelectionMode;
  final String view;
  final int itemNum;
  final Function onTap;
  final Function onSecondaryTap;
  final Function onLongPress;

  ConnectionWidgetTile({
    @required this.index,
    @required this.fileInfos,
    @required this.isLoading,
    @required this.isSelected,
    @required this.isSelectionMode,
    @required this.view,
    @required this.itemNum,
    @required this.onTap,
    @required this.onSecondaryTap,
    @required this.onLongPress,
  });

  @override
  _ConnectionWidgetTileState createState() => _ConnectionWidgetTileState();
}

class _ConnectionWidgetTileState extends State<ConnectionWidgetTile> {
  final Duration _animationDuration = Duration(milliseconds: 140);

  Widget _getTrailingButton() {
    Widget result;
    if (widget.isSelectionMode) {
      result = AnimatedContainer(
        duration: _animationDuration,
        margin: widget.view == "grid" ? EdgeInsets.all(4) : EdgeInsets.all(12),
        width: widget.view == "grid" ? 18 : 21,
        height: widget.view == "grid" ? 18 : 21,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isSelected
              ? Theme.of(context).accentColor
              : Colors.transparent,
          border: Border.all(
            color: Theme.of(context).textTheme.body1.color.withOpacity(.6),
            width: widget.isSelected ? 0 : 2,
          ),
        ),
        child: Icon(Icons.check,
            size: widget.view == "grid" ? 16 : 18,
            color: widget.isSelected
                ? Theme.of(context).accentIconTheme.color
                : Colors.transparent),
      );
    } else if (widget.fileInfos[widget.index].isDirectory) {
      result = CustomIconButton(
        icon: Icon(Icons.more_vert, size: widget.view == "view" ? 22 : null),
        size: widget.view == "view" ? 24 : 44,
        onPressed: widget.onSecondaryTap,
      );
    }
    return result;
  }

  Widget _getSubtitle() {
    String result;
    if (widget.fileInfos[widget.index].isDirectory) {
      result = "Folder, ";
    } else {
      if (widget.fileInfos[widget.index].convertedSize == null) {
        result = "Loading... ";
      } else {
        result = widget.fileInfos[widget.index].convertedSize + ", ";
      }
    }
    result += widget.fileInfos[widget.index].modificationDate;
    return Text(result);
  }

  @override
  Widget build(BuildContext context) {
    Widget result;

    if (widget.fileInfos.length > 0 && !widget.isLoading) {
      if (widget.view == "list") {
        result = ListTile(
          leading: Icon(
            widget.fileInfos[widget.index].isDirectory
                ? Icons.folder_open
                : Icons.insert_drive_file,
            color: Theme.of(context).hintColor,
          ),
          title: Text(widget.fileInfos[widget.index].name),
          trailing: _getTrailingButton(),
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
        );
      } else if (widget.view == "grid") {
        result = Container(
          margin: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? Theme.of(context).accentColor.withOpacity(.16)
                : (Provider.of<CustomTheme>(context).isLightTheme()
                    ? Color.fromRGBO(0, 0, 0, .07)
                    : Color.fromRGBO(255, 255, 255, .04)),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(6.0),
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      child: Icon(
                        widget.fileInfos[widget.index].isDirectory
                            ? Icons.folder_open
                            : Icons.insert_drive_file,
                        size: 32.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          widget.fileInfos[widget.index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                        ),
                      ),
//                      if (_getTrailingButton() != null) _getTrailingButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      } else if (widget.view == "detailed") {
        result = ListTile(
          leading: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Icon(
              widget.fileInfos[widget.index].isDirectory
                  ? Icons.folder_open
                  : Icons.insert_drive_file,
              color: Theme.of(context).hintColor,
            ),
          ),
          title: Text(widget.fileInfos[widget.index].name),
          subtitle: _getSubtitle(),
          trailing: _getTrailingButton(),
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
        );
      }
    } else {
      result = widget.index == 0
          ? Container(
              child: Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          : Container();
    }

    if (widget.view != "grid") {
      result = AnimatedContainer(
        duration: _animationDuration,
        color: widget.isSelected
            ? Theme.of(context).accentColor.withOpacity(.16)
            : Colors.transparent,
        child: result,
      );
    }

    return result;
  }
}
