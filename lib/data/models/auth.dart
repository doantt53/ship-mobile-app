import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../../utils/network_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../classes/user.dart';
import '../global.dart';

class AuthModel extends ChangeNotifier {
  String errorMessage = "";

  bool _rememberMe = false;
  bool _stayLoggedIn = true;
  bool _useBio = false;
  User _user;

  bool get rememberMe => _rememberMe;

  void handleRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("remember_me", value);
    });
  }

  bool get isBioSetup => _useBio;

  void handleIsBioSetup(bool value) {
    _useBio = value;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("use_bio", value);
    });
  }

  bool get stayLoggedIn => _stayLoggedIn;

  void handleStayLoggedIn(bool value) {
    _stayLoggedIn = value;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("stay_logged_in", value);
    });
    print(handleStayLoggedIn);
  }

  void loadSettings() async {
    var _prefs = await SharedPreferences.getInstance();
    try {
      _useBio = _prefs.getBool("use_bio") ?? false;
    } catch (e) {
      print(e);
      _useBio = false;
    }
    try {
      _rememberMe = _prefs.getBool("remember_me") ?? false;
    } catch (e) {
      print(e);
      _rememberMe = false;
    }
    try {
      _stayLoggedIn = _prefs.getBool("stay_logged_in") ?? false;
    } catch (e) {
      print(e);
      _stayLoggedIn = false;
    }

    if (_stayLoggedIn) {
      User _savedUser;
      try {
        String _saved = _prefs.getString("user_data");
        print("Saved: $_saved");
        _savedUser = User.fromJson(json.decode(_saved));
      } catch (e) {
        print("User Not Found: $e");
      }
      if (!kIsWeb && _useBio) {
        if (await biometrics()) {
          _user = _savedUser;
        }
      } else {
        _user = _savedUser;
      }
    }
    notifyListeners();
  }

  Future<bool> biometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: false);
    } catch (e) {
      print(e);
    }
    return authenticated;
  }

  User get user => _user;

  Future<User> getInfo(String token) async {
    try {
      var _data = await http.get(apiURL);
      // var _json = json.decode(json.encode(_data));
      var _newUser = User.fromJson(json.decode(_data.body)["data"]);
      _newUser?.token = token;
      return _newUser;
    } catch (e) {
      print("Could Not Load Data: $e");
      return null;
    }
  }

  Future<bool> login({
    @required String username,
    @required String password,
  }) async {
//    var uuid = new Uuid();
    String _username = username;
    String _password = password;
    int _status = 0;

    // TODO: API LOGIN CODE HERE
    String _url =
        "http://tau.dvbk.vn/API_Ship/Login?loginname=$_username&pass=$_password$key";
    print(_url);
//    var _data = await http.get(_url);
//    final String res = _data.body;
//    _status = res["LoginStatus"];
    NetworkUtil _netUtil = new NetworkUtil();
    var _data = await _netUtil.get(_url); //.then((dynamic res) {

////      _status = res["LoginStatus"];
//      // Login
//
//      //print(res.toString());
//      // if(res["error"]) throw new Exception(res["error_msg"]);
//      // return new User.map(res["user"]);rdd
//      return res["LoginStatus"];
//      return res;
//    });
//     print(_data);

//    await Future.delayed(Duration(seconds: 3));
//    print("Logging In => $_username, $_password");

    _status = _data["LoginStatus"];

    User _newUser = new User();
    _newUser.id = _data["UserID"];
    _newUser.firstname = _data["Fullname"];
    _newUser.lastname = _data["Msg"];

    print(_status);

    if (_rememberMe && _status > 0) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString("saved_username", _username);
        prefs.setString("saved_password", _password);
      });
    }
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("saved_user_id", _newUser.id.toString());
    });

    // Get Info For User
    if (_status > 0) {
      _user = _newUser;
      notifyListeners();

      SharedPreferences.getInstance().then((prefs) {
        var _save = json.encode(_user.toJson());
        print("Data: $_save");
        prefs.setString("user_data", _save);
      });
    }
    if (_status <= 0) return false;

    return true;
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("user_data", null);
    });
    return;
  }
}
