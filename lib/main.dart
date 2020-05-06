import 'package:flutter/material.dart';
import 'package:login/data/models/auth.dart';
import 'package:login/ui/blue/BluetoothPage.dart';
import 'package:login/ui/blue/bluetooth_page.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';

import 'ui/lockedscreen/HomePage.dart';
import 'ui/lockedscreen/SettingsPage.dart';
import 'ui/signin/NewAccountPage.dart';
import 'ui/signin/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeModel _model = ThemeModel();
  final AuthModel _auth = AuthModel();

  @override
  void initState() {
    try {
      _auth.loadSettings();
    } catch (e) {
      print("Error Loading Settings: $e");
    }
    try {
      _model.init();
    } catch (e) {
      print("Error Loading Theme: $e");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeModel>.value(value: _model),
          ChangeNotifierProvider<AuthModel>.value(value: _auth),
        ],
        child: Consumer<ThemeModel>(
          builder: (context, model, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: model.theme,
            home: Consumer<AuthModel>(builder: (context, model, child) {
              if (model?.user != null) return HomePage();
              return LoginPage();
            }),
            routes: <String, WidgetBuilder>{
              "/login": (BuildContext context) => LoginPage(),
              "/menu": (BuildContext context) => HomePage(),
              "/home": (BuildContext context) => HomePage(),
              "/settings": (BuildContext context) => SettingsPage(),
//              "/create": (BuildContext context) => CreateAccount(),
              "/bluetooth": (BuildContext context) => BluetoothPage(),
            },
          ),
        ));
  }
}
