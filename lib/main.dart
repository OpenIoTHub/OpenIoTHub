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
              onPressed: null),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(
                  Icons.add_circle,
                  color: Colors.white,
                ),
                onPressed: null),
          ],
        ),
        body: _buildSessions(_currentIndex),
        bottomNavigationBar: _buildBottomNavigationBar(_currentIndex));
  }

  Widget _buildSessions(int index) {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        if (i > 4) {
          return null;
        }
        return _buildRow(index);
      },
    );
  }

  Widget _buildRow(int index) {
    final alreadySaved = true;
    return new ListTile(
      title: new Text(
        index.toString(),
        style: _biggerFont,
      ),
      trailing: new IconButton(
        icon: new Icon(Icons.arrow_forward_ios),
        color: Colors.green,
        onPressed: () {
          _pushDetail();
        },
      ),
      onTap: (){},
    );
  }

  void _pushDetail() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('详情'),
            ),
            body: new Text("详情"),
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
              'User',
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
