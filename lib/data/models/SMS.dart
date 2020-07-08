import 'dart:convert';
import 'dart:ffi';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../global.dart';

class DataSMS {


  int _numMessageContent;

  DataSMS(this._numMessageContent);


  int get numMessageContent => _numMessageContent;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();


    map['numMessageContent'] = numMessageContent;

    return map;
  }

  DataSMS.fromMap(Map<String, dynamic> map) {


    this._numMessageContent = map['numMessageContent'];
  }

  factory DataSMS.fromJson(Map<String, dynamic> json) {
    return DataSMS(


    json["numMessageContent"]);
  }
  Map<String, dynamic> toJson() {
    return {"numMessageContent": numMessageContent};
  }

  @override
  String toString() {
    return 'Profile{ numMessageContent: $numMessageContent}';
  }

}
  List<DataSMS> profileFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<DataSMS>.from(data.map((item) => DataSMS.fromJson(item)));
  }

  String profileToJson(DataSMS data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }

