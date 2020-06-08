import 'dart:convert';
import 'dart:ffi';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../global.dart';

class ListShipModel{
 String ShipName;
 int ShipID;
 String NumberRegistry;

 ListShipModel({
    this.ShipName,
    this.ShipID,
    this.NumberRegistry
  });
  factory ListShipModel.fromJson(Map<String, dynamic> json){
    return ListShipModel(
        ShipName: json["ShipName"],
        ShipID: json["ShipID"],
        NumberRegistry: json["NumberRegistry"]
    );
  }
}
