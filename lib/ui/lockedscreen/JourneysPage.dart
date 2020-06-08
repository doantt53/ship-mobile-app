import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flushbar/flushbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../constants.dart';
import '../../data/models/auth.dart';
import '../app/app_drawer.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/global.dart';
import '../../data/models/ListShip.dart';
import '../../data/models/TripInfo.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:toast/toast.dart';

//Define "root widget"
//StatefulWidget



int userid = 0;
String NumberPlate = "";
int ShipId = 0;
String BeginDate = DateFormatString(DateTime.now());
String BeginTime ="00-00-00" ;
String EndDate = DateFormatString(DateTime.now());
String EndTime = "23-59-59";

Flushbar flush;
bool _wasButtonClicked;
ListShipModel _selectedShipValue;

class journeysPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MapSampleState(); //return a state's object. Where is the state's class ?
  }
}

//////////////// Lấy dữ liệu từ API
List<ListShipModel> _postList = new List<ListShipModel>();

Future<List<ListShipModel>> fetchListShip() async {
  String id = userid.toString();
  String Url = URL_LISTSHIP + id + key;
  print(Url);
  final response = await http.get(Url);
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    List<dynamic> values = new List<dynamic>();
    values = json.decode(response.body);
    print(values.length);
    if (values.length > 0) {
      //print(values[0]);
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
//          print(values[i]["ShipID"]);
          //if(values[i]["SpeedKnot"] == 0) {
          Map<String, dynamic> map = values[i];
          _postList.add(ListShipModel.fromJson(map));
          //print('Id-------${map['Lt']}');
        }
      }
    }
    return _postList;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

//////////////// Lấy dữ liệu từ API
List<TripInfoModel> _postListTripInfo = new List<TripInfoModel>();

Future<List<TripInfoModel>> fetchListTripInfo() async {
  String id = userid.toString();
  String Url = URL_TRIPINFO +
      ShipId.toString() +
      "&begin=" +
      BeginTime +
      "_" +
      BeginDate +
      "&end=" +
      EndTime +
      "_" +
      EndDate +
      key;
  print(Url);
  final response = await http.get(Url);
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    List<dynamic> values = new List<dynamic>();
    values = json.decode(response.body);
    print(values.length);
    if (values.length > 0) {
      //print(values[0]);
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
         // print(values[i]["DateStr"]);
          //if(values[i]["SpeedKnot"] == 0) {
          Map<String, dynamic> map = values[i];
          _postListTripInfo.add(TripInfoModel.fromJson(map));
          //print('Id-------${map['Lt']}');
        }
      }
    }
    return _postListTripInfo;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Set<Marker> _markers = {};
Set<Polyline> _polyline = {};

//State
class MapSampleState extends State<journeysPage> {
  GoogleMapController controller;
  List<LatLng> latlngSegment1 = List();
  List<LatLng> latlngSegment2 = List();

  static LatLng _lat1 = LatLng(20.8585911, 106.6776752);

  LatLng _lastMapPosition = _lat1;


  BitmapDescriptor get deliveryIcon {
    return BitmapDescriptor.fromAsset('assets/run.png');
  }
  BitmapDescriptor get deliveryIconRun {
    return BitmapDescriptor.fromAsset('assets/start.png');
  }
  BitmapDescriptor get deliveryIconStop {
    return BitmapDescriptor.fromAsset('assets/finish.png');
  }

  @override
  void AddPoin() {
    //line segment 1
    //latlngSegment1.add(_lat1);

    for (var i = 0; i < _postListTripInfo.length; i++) {
      double Lat = _postListTripInfo[i].Lt;
      double Lon = _postListTripInfo[i].Ln;
      LatLng _center2 = LatLng(Lat, Lon);
      LatLng _lastMapPosition = _center2;
      latlngSegment1.add(_lastMapPosition);
    }
    print("llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll");
  }

  void _clearMarker(){
    setState(() {

      latlngSegment1 = new List<LatLng>();
      _polyline = {};
      _polyline.clear();

      _markers = {}; // 20
      _markers.clear();

      _postListTripInfo = new List<TripInfoModel>();
    });
  }


  void _onMapCreateds() async {

    _clearMarker();
    await fetchListTripInfo();


    print(_postListTripInfo.length);
    if(_postListTripInfo.length == 0){
      flush = Flushbar<bool>(
        title: "Thông báo",
        message: "Tàu " + NumberPlate + " Không có hành trình trong khoảng thời gian đã chọn",
        icon: Icon(
          Icons.warning,
          color: Colors.orangeAccent,),
        mainButton: FlatButton(
          onPressed: () {
            flush.dismiss(true); // result = true
          },
          child: Text(
            "Ẩn",
            style: TextStyle(color: Colors.amber),
          ),
        ),) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
        ..show(context).then((result) {
          setState(() { // setState() is optional here
            _wasButtonClicked = result;
          });
        });
      Future.delayed(const Duration(milliseconds: 8000), () {flush.dismiss(true);});
    }else{
      AddPoin();
      setState(() {
        for (var i = 0; i < _postListTripInfo.length; i++) {

          TripInfoModel Post = new TripInfoModel();
          Post = _postListTripInfo[i];

          double Lat = _postListTripInfo[i].Lt;
          double Lon = _postListTripInfo[i].Ln;
          LatLng _center2 = LatLng(Lat, Lon);
          LatLng _lastMapPosition = _center2;

          if(i == 0) {
            print("object");
            _markers.add(Marker(
                markerId: MarkerId(_lastMapPosition.toString()),
                position: _lastMapPosition,
                //infoWindow: InfoWindow(title: _postList[i].ShipName, snippet: ""),
                infoWindow: InfoWindow(title: _postListTripInfo[i].ShipName),
                //icon: BitmapDescriptor.defaultMarker,
                rotation: _postListTripInfo[i].Angle.toDouble(),
                icon: deliveryIconRun,
                //icon:myIcon,
                onTap: () {
                  //_showDialog(Post);
                  showCustomDialogWithImage(Post);
                }
              //icon:_setSourceIcon,
            ));
          }else if(i == _postListTripInfo.length -1){
            _markers.add(Marker(
                markerId: MarkerId(_lastMapPosition.toString()),
                position: _lastMapPosition,
                //infoWindow: InfoWindow(title: _postList[i].ShipName, snippet: ""),
                infoWindow: InfoWindow(title: _postListTripInfo[i].ShipName),
                //icon: BitmapDescriptor.defaultMarker,
                rotation: _postListTripInfo[i].Angle.toDouble(),
                icon: deliveryIconStop,
                //icon:myIcon,
                onTap: () {
                  //_showDialog(Post);
                  showCustomDialogWithImage(Post);
                }
              //icon:_setSourceIcon,
            ));
          }else{
            _markers.add(Marker(
                markerId: MarkerId(_lastMapPosition.toString()),
                position: _lastMapPosition,
                //infoWindow: InfoWindow(title: _postList[i].ShipName, snippet: ""),
                infoWindow: InfoWindow(title: _postListTripInfo[i].ShipName),
                //icon: BitmapDescriptor.defaultMarker,
                rotation: _postListTripInfo[i].Angle.toDouble(),
                icon: deliveryIcon,
                //icon:myIcon,
                onTap: () {
                  //_showDialog(Post);
                  showCustomDialogWithImage(Post);
                }
              //icon:_setSourceIcon,
            ));
          }

        }
        _polyline.add(Polyline(
          polylineId: PolylineId('line1'),
          visible: true,
          //latlng is List<LatLng>
          points: latlngSegment1,
          width: 2,
          color: Colors.blue,
        ));
      });
    }
  }


  void showCustomDialogWithImage(TripInfoModel Post) {
    Dialog dialogWithImage = Dialog(
      child: Container(
        height: 250.0,
        width: 200.0,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: Text(
                Post.ShipName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Thời gian', //                              <--- text
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    Post.DateStr, //                              <--- text
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Vận tốc', //                              <--- text
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    Post.Speed.toString() + " knot", //                              <--- text
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Vị trí', //                              <--- text
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    Post.Coor.toString(), //                              <--- text
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                //RaisedButton(
                //color: Colors.blue,
                //onPressed: () {
                // Navigator.of(context).pop();
                //},
                //child: Text('Okay',style: TextStyle(fontSize: 14.0, color: Colors.white),),
                //),
                //SizedBox(width: 20,),
                RaisedButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Đóng!',
                    style: TextStyle(fontSize: 14.0, color: Colors.black38),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => dialogWithImage);
  }

  Completer<GoogleMapController> _Controller = Completer();

  static const LatLng _center =
      const LatLng(20.845724105834961, 106.71234893798828);

  LatLng _lastMapPosition0 = _center;
  MapType _currentMaptype = MapType.hybrid;

  _onMapCreated(GoogleMapController controller) {
    _Controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition0 = position.target;
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController _controllerUsername, _controllerPassword;

  bool CheckValue = true;

  bool checkboxValueCity = false;
  List<String> selectedCities = [];
  List<String> selectedCitiesTemp = [];

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);
    userid = _auth.user.id;
    fetchListShip();
    //AddPoints();
    //fetchTiBaseModel3(_auth);
    //setStateMaker(_auth);
    //_auth?.user?.firstname.toString() ?? "",
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Xem lại hành trình",
            textScaleFactor: textScaleFactor,
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.list),
                //onPressed: _showPopupSelection,
                onPressed: () {
                  //_onMapCreateds();
                  //_clearMarker();
                  BeginDate = DateFormatString(DateTime.now());
                  BeginTime ="00-00-00" ;
                  EndDate = DateFormatString(DateTime.now());
                  EndTime = "23-59-59";
                  _MyDialogState();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _MyDialog(
                            cities: _onMapCreateds,
                        );
                      });
                }),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              polylines: _polyline,
              markers: _markers,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 7.0,
              ),
              mapType: _currentMaptype,
              onCameraMove: _onCameraMove,
            ),
          ],
        ),
      ),
    );
  }
}

class _MyDialog extends StatefulWidget {
  _MyDialog({
    this.cities,
  });
  final VoidCallback cities;

  @override
  // _MyDialogState createState() => _MyDialogState(MapSampleState());
  _MyDialogState createState() => _MyDialogState();
}

String DateFormatString(DateTime dateTime) {
  final y = dateTime.year.toString().padLeft(4, '0');
  final m = dateTime.month.toString().padLeft(2, '0');
  final d = dateTime.day.toString().padLeft(2, '0');
  return "$d-$m-$y";
}

String DateFormatStringAPI(DateTime dateTime) {
  final y = dateTime.year.toString().padLeft(4, '0');
  final m = dateTime.month.toString().padLeft(2, '0');
  final d = dateTime.day.toString().padLeft(2, '0');
  return "$d-$m-$y";
}

String TimeFormatString(DateTime dateTime) {
  final h = dateTime.hour.toString().padLeft(2, '0');
  final m = dateTime.minute.toString().padLeft(2, '0');
  final s = dateTime.second.toString().padLeft(2, '0');
  return "$h:$m:$s";
}

String TimeFormatStringAPI(DateTime dateTime) {
  final h = dateTime.hour.toString().padLeft(2, '0');
  final m = dateTime.minute.toString().padLeft(2, '0');
  final s = dateTime.second.toString().padLeft(2, '0');
  return "$h-$m-$s";
}

class _MyDialogState extends State<_MyDialog> {
  //final MapSampleState logic;
  //_MyDialogState(this.logic);

  //final VoidCallback _onMapCreateds;

  String _date = DateFormatString(DateTime.now());
  String _dateEnd = DateFormatString(DateTime.now());
  String _time = "00:00:00";
  String _timeEnd = DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString() + ":" + DateTime.now().second.toString();



  List<DropdownMenuItem<ListShipModel>> buildDropdownMenuItems(List ListShipReturn) {
    List<DropdownMenuItem<ListShipModel>> items = List();
    for (ListShipModel Ship in ListShipReturn) {
      items.add(
        DropdownMenuItem(
          value: Ship,
          child: Text(Ship.ShipName),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(ListShipModel _selectedShipSend) async {
    setState(() {
      _selectedShipValue = _selectedShipSend;
      NumberPlate = _selectedShipValue.ShipName.toString();
      ShipId = _selectedShipValue.ShipID;
      print(NumberPlate);
    });
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 450.0,
        width: 200.0,
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Xem lại hành trình',
              ),
              onChanged: (string) {},
            ),
            Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButton(
                    hint: Text('Chọn biển số tàu xem hành trình'), // Not necessary for Option 1
                    value: _selectedShipValue,
                    items: buildDropdownMenuItems(_postList),
                    onChanged: onChangeDropdownItem,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true,
                          minTime: DateTime(2000, 1, 1),
                          maxTime: DateTime(2032, 12, 31), onConfirm: (date) {
                        //print('confirm $date');
                        //_date = '${date.day}-${date.month}-${date.year}';
                        _date = DateFormatString(date);
                        BeginDate = DateFormatStringAPI(date);
                        print('confirm beginDate $BeginDate -- $_date');
                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.vi);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.date_range,
                                      size: 18.0,
                                      color: Colors.teal,
                                    ),
                                    Text(
                                      " $_date",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Text(
                            "  Ngày bắt đầu",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      DatePicker.showTimePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true, onConfirm: (time) {
                        // _time = '${time.hour}:${time.minute}:${time.second}';
                        _time = TimeFormatString(time);
                        BeginTime = TimeFormatStringAPI(time);
                        print('confirm BeginTime $BeginTime -- $_time');
                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.vi);
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.access_time,
                                      size: 14.0,
                                      color: Colors.teal,
                                    ),
                                    Text(
                                      " $_time",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Text(
                            " Giờ bắt đầu",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true,
                          minTime: DateTime(2000, 1, 1),
                          maxTime: DateTime(2032, 12, 31), onConfirm: (date) {
                        // _date = '${date.day}-${date.month}-${date.year}';
                        _dateEnd = DateFormatString(date);
                        EndDate = DateFormatStringAPI(date);
                        print('confirm EndDate $EndDate -- $_dateEnd');
                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.vi);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.date_range,
                                      size: 18.0,
                                      color: Colors.teal,
                                    ),
                                    Text(
                                      " $_dateEnd",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Text(
                            "  Ngày kết thúc",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      DatePicker.showTimePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true, onConfirm: (time) {
                        //_time = '${time.hour}:${time.minute}:${time.second}';
                        _time = TimeFormatString(time);
                        EndTime = TimeFormatStringAPI(time);
                        print('confirm EndTime $EndTime -- $_time');
                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.vi);
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.access_time,
                                      size: 14.0,
                                      color: Colors.teal,
                                    ),
                                    Text(
                                      " $_timeEnd",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Text(
                            " Giờ kết thúc",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {

                   //showToast("Show Center Toast", duration: 7,gravity: Toast.TOP);
                    if(ShipId != 0){
                      widget.cities.call();
                      Navigator.of(context).pop();
                    }else{
                      flush = Flushbar<bool>(
                        title: "Lỗi !",
                        message: "Bạn chưa chọn Tàu để xem hành trình",
                        icon: Icon(
                          Icons.error,
                          color: Colors.red,),
                        mainButton: FlatButton(
                          onPressed: () {
                            flush.dismiss(true); // result = true
                          },
                          child: Text(
                            "Ẩn",
                            style: TextStyle(color: Colors.amber),
                          ),
                        ),) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
                        ..show(context).then((result) {
                          setState(() { // setState() is optional here
                            _wasButtonClicked = result;
                          });
                        });
                      Future.delayed(const Duration(milliseconds: 8000), () {flush.dismiss(true);});
                    }
                  },
                  child: Text(
                    'Xem lại hành trình',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Đóng!',
                    style: TextStyle(fontSize: 14.0, color: Colors.black38),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

