import 'dart:convert';
import 'dart:ffi';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../global.dart';


class ContactShip {
  int contactID;
  int deviceID;
  int code;
  String phone;
  String dateCreate;


  ContactShip({
    this.contactID,
    this.deviceID,
    this.code,
    this.phone,
    this.dateCreate
  });

  ContactShip.map(dynamic obj) {
    this.contactID = obj['ContactID'];
    this.deviceID = obj['DeviceID'];
    this.code = obj['Code'];
    this.phone = obj['Phone'];
    this.dateCreate = obj['DateCreate'];
  }


  int get ContactID => contactID;
  int get DeviceID => deviceID;
  int get Code => code;
  String get Phone => phone;
  String get DateCreate => dateCreate;

//  set id(int _id) => _id = _id;
//  set name(String _name) => _name = _name;
//  set message(String _message) => _message = _message;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['ContactID'] = contactID;
    map['DeviceID'] = deviceID;
    map['Code'] = code;
    map['Phone'] = phone;
    map['DateCreate'] = dateCreate;

    return map;
  }

  ContactShip.fromMap(Map<String, dynamic> map) {
    this.contactID = map['ContactID'];
    this.deviceID = map['DeviceID'];
    this.code = map['Code'];
    this.phone = map['Phone'];
    this.dateCreate = map['DateCreate'];
  }
  factory ContactShip.fromJson(Map<String, dynamic> json){
    return ContactShip(
        contactID: json["ContactID"],
        deviceID: json["DeviceID"],
        code: json["Code"],
        phone: json["Phone"],
        dateCreate: json["DateCreate"]
    );
  }
}

