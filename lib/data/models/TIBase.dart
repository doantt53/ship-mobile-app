import 'dart:convert';
import 'dart:ffi';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../global.dart';

class TiBaseModel{
  int TIBaseID;
  int ShipID;
  int DeviceID;
  int CaptainID;
  int Speed;
  double Lt;
  double Ln;
  String Date;
  String DateStr;
  String Coordinate;
  String ShipName;
  int Angle;
  int ShipStatus;
  String Fullname;
  String CMND;
  String Address;
  String DeviceName;
  String Serial;
  String Model;
  String NumberID;
  String FrequencyAction;
  String Firmware;
  String RegType;
  String RegCode;
  String FrequencyShip;
  String VHF;
  String HF;
  String CellPhone;
  String SatellitePhone;
  String SatelliteSystem;
  String IMEI;
  String NumberRegistry;
  String FlagSign;
  String Slogan;
  String IMO;
  String CityCode;
  String PortCode;
  String PortCodeSecond;
  String JobCode;
  String DateFromRegistry;
  String DateToRegistry;
  String TotalLoad;
  String MaxLong;
  String MaxWidth;
  String Waterline;
  int Wattage;
  String ColorShip;
  int Seaman;
  String DateOfManufacture;
  String ExpiryDate;
  String ShipCode;
  bool IsSoS;
  int CapacityFish;
  String SpeedFree;
  String SpeedMax;
  String DateFromRegistryStr;
  String DateToRegistryStr;
  String OwnerName;
  String OnwerPhone;
  int OwnerID;
  String SpeedKnot;

  TiBaseModel({
    this.TIBaseID,
    this.ShipID,
    this.DeviceID,
    this.CaptainID,
    this.Speed,
    this.Lt,
    this.Ln,
    this.Date,
    this.DateStr,
    this.Coordinate,
    this.ShipName,
    this.Angle,
    this.ShipStatus,
    this.Fullname,
    this.CMND,
    this.Address,
    this.DeviceName,
    this.Serial,
    this.Model,
    this.NumberID,
    this.FrequencyAction,
    this.Firmware,
    this.RegType,
    this.RegCode,
    this.FrequencyShip,
    this.VHF,
    this.HF,
    this.CellPhone,
    this.SatellitePhone,
    this.SatelliteSystem,
    this.IMEI,
    this.NumberRegistry,
    this.FlagSign,
    this.Slogan,
    this.IMO,
    this.CityCode,
    this.PortCode,
    this.PortCodeSecond,
    this.JobCode,
    this.DateFromRegistry,
    this.DateToRegistry,
    this.TotalLoad,
    this.MaxLong,
    this.MaxWidth,
    this.Waterline,
    this.Wattage,
    this.ColorShip,
    this.Seaman,
    this.DateOfManufacture,
    this.ExpiryDate,
    this.ShipCode,
    this.IsSoS,
    this.CapacityFish,
    this.SpeedFree,
    this.SpeedMax,
    this.DateFromRegistryStr,
    this.DateToRegistryStr,
    this.OwnerName,
    this.OnwerPhone,
    this.OwnerID,
    this.SpeedKnot
  });
  factory TiBaseModel.fromJson(Map<String, dynamic> json){
    return TiBaseModel(
        TIBaseID: json["TIBaseID"],
        ShipID: json["ShipID"],
        DeviceID: json["DeviceID"],
        CaptainID: json["CaptainID"],
        Speed: json["Speed"],
        Lt: json["Lt"],
        Ln: json["Ln"],
        Date: json["Date"],
        DateStr: json["DateStr"],
        Coordinate: json["Coordinate"],
        ShipName: json["ShipName"],
        Angle: json["Angle"],
        ShipStatus: json["ShipStatus"],
        Fullname: json["Fullname"],
        CMND: json["CMND"],
        Address: json["Address"],
        DeviceName: json["DeviceName"],
        Serial: json["Serial"],
        Model: json["Model"],
        NumberID: json["NumberID"],
        FrequencyAction: json["FrequencyAction"],
        Firmware: json["Firmware"],
        RegType: json["RegType"],
        RegCode: json["RegCode"],
        FrequencyShip: json["FrequencyShip"],
        VHF: json["VHF"],
        HF: json["HF"],
        CellPhone: json["CellPhone"],
        SatellitePhone: json["SatellitePhone"],
        SatelliteSystem: json["SatelliteSystem"],
        IMEI: json["IMEI"],
        NumberRegistry: json["NumberRegistry"],
        FlagSign: json["FlagSign"],
        Slogan: json["Slogan"],
        IMO: json["IMO"],
        CityCode: json["CityCode"],
        PortCode: json["PortCode"],
        PortCodeSecond: json["PortCodeSecond"],
        JobCode: json["JobCode"],
        DateFromRegistry: json["DateFromRegistry"],
        DateToRegistry: json["DateToRegistry"],
        TotalLoad: json["TotalLoad"],
        MaxLong: json["MaxLong"],
        MaxWidth: json["MaxWidth"],
        Waterline: json["Waterline"],
        Wattage: json["Wattage"],
        ColorShip: json["ColorShip"],
        Seaman: json["Seaman"],
        DateOfManufacture: json["DateOfManufacture"],
        ExpiryDate: json["ExpiryDate"],
        ShipCode: json["ShipCode"],
        IsSoS: json["IsSoS"],
        CapacityFish: json["CapacityFish"],
        SpeedFree: json["SpeedFree"],
        SpeedMax: json["SpeedMax"],
        DateFromRegistryStr: json["DateFromRegistryStr"],
        DateToRegistryStr: json["DateToRegistryStr"],
        OwnerName: json["OwnerName"],
        OnwerPhone: json["OnwerPhone"],
        OwnerID: json["OwnerID"],
        SpeedKnot: json["SpeedKnot"]
    );
  }
}



///////////////////////////////////////
Future<List<TiBaseModel>> fetchTiBaseModel1(http.Client client) async{
  final response = await client.get(URL_TIBASE);
  if(response.statusCode == 200){
         Map<String, dynamic> mapResponse = json.decode(response.body);
         final tiBases = mapResponse["data"].cast<Map<String, dynamic>>();
         final listOffTiBaseModel = await tiBases.map<TiBaseModel>((json){
           return TiBaseModel.fromJson(json);
         }).toList();
         return listOffTiBaseModel;
  }else{
    throw Exception("Lỗi!. Không lấy dược dữ liệu từ server");
  }
}