import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
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
  @override
  _ListViewMessageState createState() => new _ListViewMessageState();
}

class _ListViewMessageState extends State<ContactsShipPage> {
  List<ContactShip> items = new List();
  DatabaseHelper db = new DatabaseHelper();

  @override
  void GetContact(AuthModel _auth) async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) { //connected
        //items = new List();
        fetchContactShipModels(_auth);
      }
    } on SocketException catch (_) {
      print('not connected');
      db.getAllMessages().then((notes) {
        setState(() {
          notes.forEach((note) {
            items.add(ContactShip.fromMap(note));
          });
        });
      });
    }
  }

  List<ContactShip> _postList = new List<ContactShip>();

  Future<List<ContactShip>> fetchContactShipModels(AuthModel _auth) async {
    //String id = _auth.user.id.toString();
    //String Url = URL_CONTACT + id + key;
    String Url = URL_CONTACT + "bktest" + key;
    print(Url);
    final response = await http.get(Url);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<dynamic> values = new List<dynamic>();

      values = json.decode(response.body);

      print(values.length);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            _postList.add(ContactShip.fromJson(map));
          }
        }
      }
      return _postList;
    } else {
      throw Exception('Failed to load post');
    }
  }




  @override
  Widget build(BuildContext context){

    final _auth = Provider.of<AuthModel>(context, listen: true);
    GetContact(_auth);
    print(_postList.length);

    return MaterialApp(
      title: 'JSA ListView Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Danh sách tin nhắn'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: _postList.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                String img = _postList[position].deviceID.toString().substring(0, 1);
                String des = _postList[position].Phone;
                if (des.length > 70) {
                  des = _postList[position].Phone.substring(0, 70);
                  print("==> " + des);
                }
                return Column(
                  children: <Widget>[
                    ListTile(
                        title: Text('${_postList[position].deviceID}'),
                        subtitle: Text(des),
                        leading: CircleAvatar(
                          child: Text(img),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                        onTap: () async {
                          ContactShip selected = _postList[position];

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
            final _auth = Provider.of<AuthModel>(context, listen: true);
            GetContact(_auth);

//            setState(() {
//            });
          },
        ),
      ),
    );
  }
}
