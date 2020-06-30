import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ship/utils/database_helper.dart';

import '../../data/models/ContactShip.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/global.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';

import 'AddressAndUpdate_page.dart';
import 'address_page.dart';

class ContactsShipPage extends StatefulWidget {
  final bool isLogin;

  ContactsShipPage(this.isLogin);

  @override
  _ListViewContactState createState() => new _ListViewContactState();
}

class _ListViewContactState extends State<ContactsShipPage> {
  bool _isLogin = false;
  BuildContext context; // lam delete
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
        items = [];
        setState(() {
          print("Length = ${_lstContacts.length}");
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
    String sUserId = _prefs.getString("saved_user_id") ?? "";
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách số điện thoại'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: (_isLogin == true)
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    final selected = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FormAddScreen(contactShip: null)));
//              setState(() {
//              });
                    getContacts();
                  },
                )
              ]
            : <Widget>[],
      ),
      body: Center(
        child: ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (context, position) {
              ContactShip contactShip = items[position];
              final item = items[position];
              String img = items[position].name.toString().substring(0, 1);
              String des = items[position].phone;
              if (des.length > 70) {
                des = items[position].phone.substring(0, 70);
                print("==> " + des);
              }

              return Dismissible(
                key: Key(item.name),
                confirmDismiss: (DismissDirection direction) async {
                  return await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Thông báo"),
                          content: Text("Xóa tên liên lạc ${contactShip.name}?"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Có"),
                              onPressed: () async {
                                bool delete = await DeleteContact(contactShip);
                                Navigator.pop(context);
                                getContacts();
                              },
                            ),
                            FlatButton(
                              child: Text("Không"),
                              onPressed: () {
                                Navigator.pop(context);
                                getContacts();
                              },
                            )
                          ],
                        );
                      });
                },
                background: Container(color: Colors.blue),
                child: ListTile(
                    title: Text('${items[position].name}'),
                    subtitle: Text(des),
                    leading: CircleAvatar(
                      child: Text(img),
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                    onTap: () async {
                      final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PageFull(contactShip: contactShip)));
                      getContacts();
                    }),
              );
            }),
      ),
    );
  }
}
//goi api delete
Future<bool> DeleteContact(ContactShip data) async {
  String _url = URL_DELETE + "deviceID=${data.deviceID}&Code=${data.code}";
  print(_url);

  final response = await http.get(_url);
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}