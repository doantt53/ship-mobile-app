import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Drawer Layout Demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Drawer Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
          appBar: AppBar(
            title: Text('Developine App Bar'),
          ),
          endDrawer: Drawer(
          elevation: 20.0,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text('Hammad Tariq'),
                accountEmail: Text('developine.com@gmail.com'),
                currentAccountPicture:
                Image.network('https://hammad-tariq.com/img/profile.png'),
                decoration: BoxDecoration(color: Colors.blueAccent),
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Drawer layout Item 1'),
                onTap: () {
                  // This line code will close drawer programatically....
                  Navigator.pop(context);
                },
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(Icons.accessibility),
                title: Text('Drawer layout Item 2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(Icons.account_box),
                title: Text('Drawer layout Item 3'),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          )),
    ));
  }
}