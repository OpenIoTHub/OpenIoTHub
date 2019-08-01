import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';
import 'shared.dart';

class ConnectionDialog extends StatelessWidget {
  final BuildContext context;
  final Connection connection;
  final bool isConnectionPage;
  final IconData primaryButtonIconData;
  final String primaryButtonLabel;
  final GestureTapCallback primaryButtonOnPressed;
  final bool hasSecondaryButton;
  final IconData secondaryButtonIconData;
  final String secondaryButtonLabel;
  final GestureTapCallback secondaryButtonOnPressed;

  ConnectionDialog({
    @required this.context,
    @required this.connection,
    this.isConnectionPage = false,
    @required this.primaryButtonIconData,
    @required this.primaryButtonLabel,
    @required this.primaryButtonOnPressed,
    this.hasSecondaryButton = false,
    this.secondaryButtonIconData,
    this.secondaryButtonLabel,
    this.secondaryButtonOnPressed,
  });

  void show() {
    customShowDialog(
      context: context,
      builder: (context) => this,
    );
  }

  Row _buildPasswordRow(int passwordLength) {
    if (passwordLength == 0) passwordLength = 1;
    List<Widget> widgets = [];
    for (int i = 0; i < passwordLength; i++) {
      widgets.add(
        Container(
          margin: EdgeInsets.only(top: 8.0, right: 4.0),
          width: 4.0,
          height: 4.0,
          decoration: BoxDecoration(
            color: Theme.of(context).textTheme.body1.color,
            shape: BoxShape.circle,
          ),
        ),
      );
    }
    return Row(children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: Text(
        isConnectionPage
            ? "Current connection"
            : (connection.name != "" ? connection.name : connection.address),
      ),
      content: Container(
        width: 400.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Opacity(
              opacity: .8,
              child: Table(
                columnWidths: {0: FixedColumnWidth(120.0)},
                children: [
                  isConnectionPage
                      ? TableRow(children: [
                          Container(),
                          Container(),
                        ])
                      : TableRow(children: [
                          Text("Name:"),
                          Text(connection.name != "" ? connection.name : "-"),
                        ]),
                  TableRow(children: [
                    Text("Address:"),
                    Text(connection.address),
                  ]),
                  TableRow(children: [
                    Text("Port:"),
                    Text(connection.port),
                  ]),
                  TableRow(children: [
                    Text("Username:"),
                    Text(
                      connection.username != "" ? connection.username : "-",
                      style: TextStyle(),
                    )
                  ]),
                  TableRow(
                    children: [
                      Text("Password/Key:"),
                      connection.passwordOrKey != ""
                          ? _buildPasswordRow(connection.passwordOrKey.length)
                          : Text("-"),
                    ],
                  ),
                  TableRow(children: [
                    Text("Path:"),
                    Text(connection.path),
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        hasSecondaryButton
            ? FlatButton(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 3.5, bottom: 1.0),
                      child: Icon(
                        secondaryButtonIconData,
                        size: 19.0,
                      ),
                    ),
                    Text(secondaryButtonLabel),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding: EdgeInsets.only(
                  top: 8.5,
                  bottom: 8.0,
                  left: 12.0,
                  right: 14.0,
                ),
                onPressed: secondaryButtonOnPressed,
              )
            : null,
        RaisedButton(
          color: Theme.of(context).accentColor,
          splashColor: Colors.black12,
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 3.5, bottom: 1.0),
                child: Icon(
                  primaryButtonIconData,
                  size: 19.0,
                  color: Provider.of<CustomTheme>(context).isLightTheme()
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              Text(
                primaryButtonLabel,
                style: TextStyle(
                  color: Provider.of<CustomTheme>(context).isLightTheme()
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: EdgeInsets.only(
            top: 8.5,
            bottom: 8.0,
            left: 12.0,
            right: 14.0,
          ),
          elevation: .0,
          onPressed: primaryButtonOnPressed,
        ),
        SizedBox(width: .0),
      ],
    );
  }
}
