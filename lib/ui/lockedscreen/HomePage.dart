import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../data/models/auth.dart';
import '../app/app_drawer.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/global.dart';
import '../../data/models/TIBase.dart';
import 'MonutorPage.dart';
import 'JourneysPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MapSampleState(); //return a state's object. Where is the state's class ?
  }
}

//State
class MapSampleState extends State<HomePage> {
  int _currentIndex = 0;
  final tabs=[
    Center(child: monitorPage(),),
    Center(child: journeysPage(),),
    //Center(child: Text('Home3'),),
   // Center(child: Text('Home4'),),
  ];


  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);
    //_auth?.user?.firstname.toString() ?? "",
    return Scaffold(
      //appBar: AppBar(

      //),
      //drawer: AppDrawer(),

      // ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, //Bị trí tab Active
        type: BottomNavigationBarType.fixed,
        iconSize: 20,
        selectedFontSize: 15,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.gps_fixed),
              title: Text('Giám sát tàu'),
              backgroundColor: Colors.blue
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text('Hành trình tàu'),
              backgroundColor: Colors.blue
          ),
        ],
        // Sự kiện Click màn hình index vị trí click
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

