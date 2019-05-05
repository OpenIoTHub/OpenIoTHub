import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NAT Cloud',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '内网访问工具'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _bottomNavigationColor = Colors.blue;
  int _currentIndex = 0;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: new IconButton(
              icon: new Icon(
                Icons.pages,
                color: Colors.white,
              ),
              onPressed: () {}),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(
                  Icons.add_circle,
                  color: Colors.white,
                ),
                onPressed: () {}),
          ],
        ),
        body: _buildBody(_currentIndex),
        bottomNavigationBar: _buildBottomNavigationBar(_currentIndex));
  }

//通过index判断展现的类型
  Widget _buildBody(int index) {
//    0 内网Session
//    1 TCP
//    2 UDP
//    3 FTP
//    4 账号
    switch (index) {
      case 0 :
        return _buildSessionList();
        break;
      case 1 :
        return _buildTCPList();
        break;
      case 2 :
        return _buildUDPList();
        break;
      case 3 :
        return _buildFTPList();
        break;
      case 4 :
        return _buildAccount();
        break;
    }
    return new Text("没有匹配的内容");
  }

  Widget _buildSessionList() {
    final _result = new Set<String>();
    _result.add("家");
    _result.add("公司");
    final tiles = _result.map(
          (pair) {
        return new ListTile(
          title: new Text(
            pair,
            style: _biggerFont,
          ),
          trailing: new IconButton(
            icon: new Icon(Icons.arrow_forward_ios),
            color: Colors.green,
            onPressed: () {
              _pushDetail();
            },
          ),
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return new ListView(children: divided);
  }

  Widget _buildTCPList() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        if (i > 4) {
          return null;
        }
        return _buildRow();
      },
    );
  }

  Widget _buildUDPList() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        if (i > 4) {
          return null;
        }
        return _buildRow();
      },
    );
  }

  Widget _buildFTPList() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        if (i > 4) {
          return null;
        }
        return _buildRow();
      },
    );
  }

  Widget _buildAccount() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        if (i > 4) {
          return null;
        }
        return _buildRow();
      },
    );
  }

  Widget _buildRow() {
    return new ListTile(
      title: new Text(
        "Row",
        style: _biggerFont,
      ),
      trailing: new IconButton(
        icon: new Icon(Icons.arrow_forward_ios),
        color: Colors.green,
        onPressed: () {
          _pushDetail();
        },
      ),
      onTap: () {},
    );
  }

  void _pushDetail() {
    final _result = new Set<String>();
    _result.add("第一行");
    _result.add("第二行");
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _result.map(
                (pair) {
              return new ListTile(
                title: new Text(
                  pair,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('详情'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar(int index) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _bottomNavigationColor,
            ),
            title: Text(
              '内网',
              style: TextStyle(color: _bottomNavigationColor),
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.adjust,
              color: _bottomNavigationColor,
            ),
            title: Text(
              'TCP',
              style: TextStyle(color: _bottomNavigationColor),
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.ac_unit,
              color: _bottomNavigationColor,
            ),
            title: Text(
              'UDP',
              style: TextStyle(color: _bottomNavigationColor),
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.airplay,
              color: _bottomNavigationColor,
            ),
            title: Text(
              'FTP',
              style: TextStyle(color: _bottomNavigationColor),
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.supervised_user_circle,
              color: _bottomNavigationColor,
            ),
            title: Text(
              '我',
              style: TextStyle(color: _bottomNavigationColor),
            )),
      ],
      currentIndex: index,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
