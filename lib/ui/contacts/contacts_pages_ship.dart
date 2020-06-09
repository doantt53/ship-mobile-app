import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ship/data/models/message.dart';
import 'package:ship/utils/database_helper.dart';

import '../../data/models/ContactShip.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/global.dart';
import '../../data/models/auth.dart';

import 'dart:async';
import 'package:flutter/rendering.dart';

import 'package:provider/provider.dart';

class ContactsShipPage extends StatefulWidget {
  final bool isLogin;

  ContactsShipPage(this.isLogin);

  @override
  _ListViewContactState createState() => new _ListViewContactState();
}

class _ListViewContactState extends State<ContactsShipPage> {
  bool _isLogin = false;

  List<ContactShip> items = new List();

  DatabaseHelper db = new DatabaseHelper();

  List<ContactShip> _lstContacts = new List<ContactShip>();

  void getContacts() async {
    _lstContacts = new List();
    print("Login is = $_isLogin");
    if (_isLogin == true) {
      bool network = await checkNetworkStatus();
      if (network) {
        await fetchContactShipModels();
        await db.deleteAllContacts(); // Delete database
        setState(() {
          for (var i = 0; i < _lstContacts.length; i++) {
            items.add(_lstContacts[i]);
            db.saveContactDetail(_lstContacts[i]); // Save db
          }
        });
      }
    } else {
      // Get all contacts
      await db.getAllContacts().then((notes) {
        notes.forEach((note) {
          _lstContacts.add(ContactShip.fromMap(note));
        });
      });

      setState(() {
        for (var i = 0; i < _lstContacts.length; i++) {
          items.add(_lstContacts[i]);
        }
      });
    }
  }

  Future<bool> checkNetworkStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  Future<List<ContactShip>> fetchContactShipModels() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String sUserId = "43"; //= _prefs.getString("saved_user_id") ?? "";
    print("sUserId => $sUserId");

    String _url = URL_CONTACT + sUserId + key;
    final response = await http.get(_url);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<dynamic> values = new List<dynamic>();
      values = json.decode(response.body);
      print(values.length);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            _lstContacts.add(ContactShip.fromJson(map));
          }
        }
      }
      return _lstContacts;
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();

    this._isLogin = widget.isLogin;

    getContacts();
  }

  @override
  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'JSA ListView Demo',
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách số điện thoại'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (context, position) {
              String img = items[position].name.toString().substring(0, 1);
              String des = items[position].phone;
              if (des.length > 70) {
                des = items[position].phone.substring(0, 70);
                print("==> " + des);
              }
              return Column(
                children: <Widget>[
                  ListTile(
                      title: Text('${items[position].name}'),
                      subtitle: Text(des),
                      leading: CircleAvatar(
                        child: Text(img),
                        backgroundColor: Theme.of(context).accentColor,
                      ),
                      onTap: () async {
                        ContactShip selected = items[position];

                        // Return contact selected
                        Navigator.of(context).pop(selected);
                      }),
                  Divider(height: 5.0),
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () async {
          //final _auth = Provider.of<AuthModel>(context, listen: true);
          setState(() {
            getContacts();
          });
        },
      ),
    );
//    );
  }
}
