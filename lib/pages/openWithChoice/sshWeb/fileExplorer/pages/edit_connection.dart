import 'package:flutter/material.dart';

import 'pages.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class EditConnectionPage extends StatefulWidget {
  final bool isNew;
  final int index;

  EditConnectionPage({this.isNew = false, this.index});

  @override
  _EditConnectionPageState createState() => _EditConnectionPageState();
}

class _EditConnectionPageState extends State<EditConnectionPage> {
  Connection _connection = Connection();

  bool _addToFavorites = false;
  bool _addressIsEntered = true;
  bool _passwordWasChanged = false;

  Map<String, TextEditingController> _textEditingController = {
    "name": TextEditingController(),
    "address": TextEditingController(),
    "port": TextEditingController(),
    "username": TextEditingController(),
    "passwordOrKey": TextEditingController(),
    "path": TextEditingController()
  };

  List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  Container _buildTextField({
    String label,
    String hint,
    String key,
    bool isPassword = false,
    FocusNode focusNode,
    int index,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: _textEditingController[key],
        focusNode: focusNodes[index],
        cursorColor: Theme.of(context).accentColor,
        obscureText: isPassword,
        autocorrect: key == "name",
        textInputAction:
            label == "Path" ? TextInputAction.done : TextInputAction.next,
        keyboardType: key == "port" ? TextInputType.numberWithOptions() : null,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).accentColor, width: 2.0),
          ),
          labelText: label,
          hintText: hint,
          errorText: !_addressIsEntered && label == "地址*"
              ? "请输入一个地址"
              : null,
          suffixIcon: key == "passwordOrKey" &&
                  !_passwordWasChanged &&
                  _textEditingController[key].text != ""
              ? CustomIconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).textTheme.body1.color,
                  ),
                  onPressed: () {
                    _textEditingController[key].text = "";
                    _connection.setter(key, "");
                    setState(() => _passwordWasChanged = true);
                  },
                )
              : null,
        ),
        onChanged: (String value) {
          _connection.setter(key, value);
          if (key == "passwordOrKey") {
            setState(() => _passwordWasChanged = true);
          }
        },
        onSubmitted: (String value) {
          if (index < focusNodes.length - 1) {
            FocusScope.of(context).requestFocus(focusNodes[index + 1]);
          }
        },
      ),
    );
  }

  @override
  void initState() {
    if (!widget.isNew) {
      Map<String, String> map = {};
      _textEditingController.forEach((k, v) {
        map.addAll(
            {k: HomePage.favoritesPage.connections[widget.index].toMap()[k]});
        _textEditingController[k].text =
            HomePage.favoritesPage.connections[widget.index].toMap()[k];
      });
      _connection = Connection.fromMap(map);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        notchMargin: 6.0,
        shape: CircularNotchedRectangle(),
        elevation: 8.0,
        child: Container(
          height: 55.0,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                widget.isNew
                    ? "Add a new SFTP connection"
                    : "Edit SFTP connection",
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: "fab",
        elevation: 4.0,
        child: Icon(Icons.done),
        onPressed: () {
          if (_connection.address != null && _connection.address != "") {
            if (widget.isNew) {
              if (_addToFavorites) {
                HomePage.favoritesPage = HomePage.favoritesPage
                  ..addToJson(_connection)
                  ..setConnectionsFromJson();
              }
              HomePage.recentlyAddedPage = HomePage.recentlyAddedPage
                ..addToJson(_connection)
                ..setConnectionsFromJson();
              Navigator.pop(context);
            } else {
              HomePage.favoritesPage.insertToJson(widget.index, _connection);
              HomePage.favoritesPage.removeFromJsonAt(widget.index + 1);
              HomePage.favoritesPage = HomePage.favoritesPage
                ..setConnectionsFromJson();
              Navigator.pop(context);
            }
          } else {
            setState(() {
              _addressIsEntered = false;
            });
          }
        },
      ),
      body: SafeArea(
        child: Scrollbar(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 20.0,
                  bottom: 4.0,
                ),
                child: Column(children: <Widget>[
                  _buildTextField(
                    label: "名称",
                    key: "name",
                    index: 0,
                  ),
                  _buildTextField(
                    label: "地址*",
                    key: "address",
                    index: 1,
                  ),
                  _buildTextField(
                    label: "端口",
                    hint: "22",
                    key: "port",
                    index: 2,
                  ),
                  _buildTextField(
                    label: "用户名",
                    key: "username",
                    index: 3,
                  ),
                  _buildTextField(
                    label: "密码或者秘钥",
                    key: "passwordOrKey",
                    isPassword: true,
                    index: 4,
                  ),
                  _buildTextField(
                    label: "路径",
                    key: "path",
                    index: 5,
                  ),
                ]),
              ),
              widget.isNew
                  ? CheckboxListTile(
                      activeColor: Theme.of(context).accentColor,
                      secondary: Icon(Icons.star_border),
                      title: Padding(
                        padding: EdgeInsets.only(top: 2.0),
                        child: Text(
                          "Add to Favorites",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.4,
                          ),
                        ),
                      ),
                      value: _addToFavorites,
                      onChanged: (bool value) {
                        setState(() {
                          _addToFavorites = value;
                        });
                      },
                    )
                  : Container(),
              SizedBox(
                height: 76.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
