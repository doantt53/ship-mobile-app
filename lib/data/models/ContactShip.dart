import 'dart:convert';
import 'dart:ffi';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../global.dart';

class ContactShip {
  int _id;
  int _contactID;
  int _deviceID;
  int _code;
  String _phone;
  String _dateCreate;
  String _name;

  ContactShip(this._contactID, this._deviceID, this._code, this._phone,
      this._dateCreate, this._name);

//  ContactShip.map(dynamic obj) {
//    this.contactID = obj['ContactID'];
//    this.deviceID = obj['DeviceID'];
//    this.code = obj['Code'];
//    this.phone = obj['Phone'];
//    this.dateCreate = obj['DateCreate'];
//    this.name = obj['Name'];
//  }

  int get id => _id;
  int get contactID => _contactID;
  int get deviceID => _deviceID;
  int get code => _code;
  String get phone => _phone;
  String get dateCreate => _dateCreate;
  String get name => _name;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['contactID'] = contactID;
    map['deviceID'] = deviceID;
    map['code'] = code;
    map['phone'] = phone;
    map['dateCreate'] = dateCreate;
    map['name'] = name;

    return map;
  }

  ContactShip.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._contactID = map['contactID'];
    this._deviceID = map['deviceID'];
    this._code = map['code'];
    this._phone = map['phone'];
    this._dateCreate = map['dateCreate'];
    this._name = map['name'];
  }

  factory ContactShip.fromJson(Map<String, dynamic> json) {
    return ContactShip(
        json["ContactID"],
        json["DeviceID"],
        json["Code"],
        json["Phone"],
        json["DateCreate"],
        json["Name"]);
  }


}
