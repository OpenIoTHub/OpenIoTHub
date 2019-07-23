import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/pages.dart';
import '../services/services.dart';
import 'shared.dart';

class QuickConnectionSheet extends StatelessWidget {
  final BuildContext context;
  final Function onFail;
  QuickConnectionSheet(this.context, {this.onFail});

  void show() {
    showCustomModalBottomSheet(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<FocusNode> _focusNodes = [FocusNode(), FocusNode(), FocusNode()];

    Connection _connection = Connection();
    String _mainTextInput;
    bool _mainInputIsValid = true;
    bool _showUsernameInput = true;
    bool _showError = false;

    void _setConnection() {
      _connection = Connection();
      if (_mainTextInput == null || _mainTextInput == "") {
        _mainInputIsValid = false;
      } else {
        _mainInputIsValid = true;
        bool usernameIsValid = false;
        String username;
        int atSignsNumber = 0;
        for (int i = 0; i < _mainTextInput.length; i++) {
          if (_mainTextInput[i] == "@") {
            atSignsNumber++;
            username = _mainTextInput.substring(0, i);
            usernameIsValid = true;
          }
        }
        if (atSignsNumber > 1) {
          _mainInputIsValid = false;
        }
        if (_mainInputIsValid) {
          if (usernameIsValid) {
            for (int i = 0; i < username.length; i++) {
              if (_mainTextInput[i] == ":" ||
                  _mainTextInput[i] == "/" ||
                  _mainTextInput[i] == " ") {
                username = username.substring(i + 1);
              }
            }
          }
          int addressStartIndex = username == null ? 0 : username.length + 1;
          String address = _mainTextInput.substring(addressStartIndex);
          String port = "22";
          int colonNumber = 0;
          for (int i = addressStartIndex; i < _mainTextInput.length; i++) {
            if (_mainTextInput[i] == ":") {
              colonNumber++;
              port = _mainTextInput.substring(i + 1);
              address = _mainTextInput.substring(addressStartIndex, i);
            }
          }
          if (colonNumber > 1) {
            _mainInputIsValid = false;
          } else {
            if (usernameIsValid) _connection.username = username;
            _connection.address = address;
            _connection.port = port;
          }
        }
      }
    }

    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: StatefulBuilder(builder: (context, setState2) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Quick connect",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.0),
                TextField(
                  autofocus: true,
                  autocorrect: false,
                  focusNode: _focusNodes[0],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: "[username@]address[:port]",
                    errorText: _showError ? "Input is not valid" : null,
                  ),
                  onChanged: (String value) {
                    _showError = false;
                    _mainTextInput = value;
                    _setConnection();
                    if (_mainInputIsValid) {
                      if (_connection.username == null ||
                          _connection.username == "") {
                        _showUsernameInput = true;
                      } else {
                        _showUsernameInput = false;
                      }
                    }
                  },
                  onSubmitted: (String value) => FocusScope.of(context)
                      .requestFocus(_focusNodes[_showUsernameInput ? 1 : 2]),
                ),
                Divider(height: 20.0),
                if (_showUsernameInput)
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: TextField(
                      autofocus: true,
                      autocorrect: false,
                      focusNode: _focusNodes[1],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: "Username"),
                      onChanged: (String value) => _connection.username = value,
                      onSubmitted: (String value) =>
                          FocusScope.of(context).requestFocus(_focusNodes[2]),
                    ),
                  ),
                TextField(
                  autofocus: true,
                  obscureText: true,
                  focusNode: _focusNodes[2],
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(labelText: "Password"),
                  onChanged: (String value) =>
                      _connection.passwordOrKey = value,
                ),
                Divider(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        splashColor: Colors.black12,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 3.5, top: 1),
                                child: Icon(
                                  Icons.flash_on,
                                  size: 19.0,
                                  color: Provider.of<CustomTheme>(context)
                                          .isLightTheme()
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Text(
                                "Connect",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Provider.of<CustomTheme>(context)
                                            .isLightTheme()
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ],
                          ),
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
                        onPressed: () {
                          if (_mainInputIsValid &&
                              _connection.address != null) {
                            customShowDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => Center(
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .dialogBackgroundColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                            );
                            HomePage.recentlyAddedPage.addToJson(_connection);
                            HomePage.recentlyAddedPage.setConnectionsFromJson();
                            Navigator.pop(context);
                            ConnectionMethods.connectClient(
                              context,
                              address: _connection.address,
                              port: int.parse(_connection.port),
                              username: _connection.username,
                              passwordOrKey: _connection.passwordOrKey,
                            ).then((bool connected) {
                              Navigator.pop(context);
                              if (connected) {
                                ConnectionMethods.connect(context, _connection);
                              } else {
                                onFail();
                              }
                            });
                          } else {
                            _mainInputIsValid = false;
                            _showError = true;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
