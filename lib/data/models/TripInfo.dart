import 'dart:convert';
import 'dart:ffi';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../global.dart';


class TripInfoModel{
  String DateStr;
  int Speed;
  String Date;
  String Coor;
  int Angle;
  double Lt;
  double Ln;
  int Battery;
  int TripInfoID;
  String ShipName;
  bool IsSatellite;
  String IsPower;
  TripInfoModel({
    this.DateStr,
    this.Speed,
    this.Date,
    this.Coor,
    this.Angle,
    this.Lt,
    this.Ln,
    this.Battery,
    this.TripInfoID,
    this.ShipName,
    this.IsSatellite,
    this.IsPower
  });
  factory TripInfoModel.fromJson(Map<String, dynamic> json){
    return TripInfoModel(
      DateStr: json["DateStr"],
      Speed: json["Speed"],
      Date: json["Date"],
      Coor: json["Coor"],
      Angle: json["Angle"],
      Lt: json["Lt"],
      Ln: json["Ln"],
      Battery: json["Battery"],
      TripInfoID: json["TripInfoID"],
      ShipName: json["ShipName"],
      IsSatellite: json["IsSatellite"],
      IsPower: json["IsPower"],
    );
  }
}