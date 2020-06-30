import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ship/ui/blue/blue_page.dart';
import 'package:ship/ui/blue/bluetooth.dart';
import '../../constants.dart';
import '../../data/models/auth.dart';
import '../../utils/popUp.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.username});

  final String username;





  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String _status = 'no-action';
  String _username, _password;

  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _controllerUsername, _controllerPassword;

  @override
  initState() {
    _controllerUsername = TextEditingController(text: widget?.username ?? "");
    _controllerPassword = TextEditingController();
    _loadUsername();
    super.initState();
    print(_status);
  }

  void _loadUsername() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _username = _prefs.getString("saved_username") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;

      var _password = _prefs.getString("saved_password") ?? "";
      var userID = _prefs.getString("userid") ?? "";

      if (_remeberMe) {
        _controllerUsername.text = _username ?? "";
        _controllerPassword.text = _password ?? "";
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          key: PageStorageKey("Divider 1"),
          children: <Widget>[
            SizedBox(
              height: 120.0,
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/logobk.png',
                    fit: BoxFit.cover,
                    height: 10, // set your height
                    width: 50, // and width here
                  )),
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(labelText: 'Tên đăng nhập'),
                      validator: (val) =>
                          val.length < 1 ? 'Vui lòng nhập tên đăng nhập' : null,
                      onSaved: (val) => _username = val,
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      controller: _controllerUsername,
                      autocorrect: false,
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(labelText: 'Mật khẩu'),
                      validator: (val) =>
                          val.length < 1 ? 'Vui lòng nhập mật khẩu' : null,
                      onSaved: (val) => _password = val,
                      obscureText: true,
                      controller: _controllerPassword,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Nhớ tên đăng nhập & mật khẩu',
                textScaleFactor: textScaleFactor,
              ),
              trailing: Switch.adaptive(
                onChanged: _auth.handleRememberMe,
                value: _auth.rememberMe,
              ),
            ),
            ListTile(
              title: RaisedButton(
                child: Text(
                  'Đăng nhập',
                  textScaleFactor: textScaleFactor,
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () {
                  final form = formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    final snackbar = SnackBar(
                      duration: Duration(seconds: 30),
                      content: Row(
                        children: <Widget>[
                          CircularProgressIndicator(),
                          Text("  Đang đăng nhập ...")
                        ],
                      ),
                    );
                    _scaffoldKey.currentState.showSnackBar(snackbar);

                    setState(() => this._status = 'loading');
                    _auth
                        .login(
                      username: _username.toString().toLowerCase().trim(),
                      password: _password.toString().trim(),
                    )
                        .then((result) {
                      if (result) {
                      } else {
                        print(result);
                        setState(() => this._status = 'reject');
                        showAlertPopup(context, 'Đăng nhập lỗi',
                            'Tên đăng nhập hoặc mật khẩu không đúng.');
                      }
//                      // if (!globals.isBioSetup) {
//                      //   setState(() {
//                      //     print('Bio No Longer Setup');
//                      //   });
//                      // }
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                    });
                  }
                },
              ),
              // trailing: !globals.isBioSetup
              //     ? null
              //     : NativeButton(
              //         child: Icon(
              //           Icons.fingerprint,
              //           color: Colors.white,
              //         ),
              //         color: Colors.redAccent[400],
              //         onPressed: globals.isBioSetup
              //             ? loginWithBio
              //             : () {
              //                 globals.Utility.showAlertPopup(context, 'Info',
              //                     "Please Enable in Settings after you Login");
              //               },
              //       ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
//                return FindDevicesScreen(false);
//                return ContactsShipPage(false);
                return BlueDevicesScreen(false);
              },
            ),
          );

//          // Add your onPressed code here!
//          final BluetoothDevice selectedDevice =
//          await Navigator.of(context).push(
//            MaterialPageRoute(
//              builder: (context) {
//                return SelectBondedDevicePage(checkAvailability: false);
//              },
//            ),
//          );
//
//          if (selectedDevice != null) {
//            print('Connect -> selected ' + selectedDevice.address);
//            Navigator.of(context).push(MaterialPageRoute(
//              builder: (context) {
//                return ChatPage(server: selectedDevice);
//              },
//            ));
//          } else {
//            print('Connect -> no device selected');
//          }

//<<<<<<< HEAD
//
//
//=======
//>>>>>>> origin/master
//          await Navigator.of(context).push(
//            MaterialPageRoute(
//              builder: (context) {
//                return SelectBondedDevicePage(checkAvailability: false);
//              },
//            ),
//          );

//<<<<<<< HEAD
//=======
//
//>>>>>>> origin/master
//          final PermissionStatus permissionStatus = await _getPermission();
//          if (permissionStatus == PermissionStatus.granted) {
//            Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => ContactsPage(title: 'Flutter Contacts')));
//          } else {
//            //If permissions have been denied show standard cupertino alert dialog
//            showDialog(
//                context: context,
//                builder: (BuildContext context) =>
//                    CupertinoAlertDialog(
//                      title: Text('Permissions error'),
//                      content: Text('Please enable contacts access '
//                          'permission in system settings'),
//                      actions: <Widget>[
//                        CupertinoDialogAction(
//                          child: Text('OK'),
//                          onPressed: () => Navigator.of(context).pop(),
//                        )
//                      ],
//                    ));
//          }
        },
        tooltip: 'Tin nhắn',
        child: Icon(Icons.message),
      ),
    );
  }

//  Future<PermissionStatus> _getPermission() async {
//    final PermissionStatus permission = await PermissionHandler()
//        .checkPermissionStatus(PermissionGroup.contacts);
//    if (permission != PermissionStatus.granted) {
//      final Map<PermissionGroup, PermissionStatus> permissionStatus =
//          await PermissionHandler()
//              .requestPermissions([PermissionGroup.contacts]);
//      return permissionStatus[PermissionGroup.contacts] ??
//          PermissionStatus.unknown;
//    } else {
//      return permission;
//    }
//  }
}
