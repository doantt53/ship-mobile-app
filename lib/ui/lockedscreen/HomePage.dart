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

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MapSampleState(); //return a state's object. Where is the state's class ?
  }
}

//////////////// Lấy dữ liệu từ API
List<TiBaseModel> _postList = new List<TiBaseModel>();

Future<List<TiBaseModel>> fetchTiBaseModel3(AuthModel _auth) async {
  String id = _auth.user.id.toString();
  String Url = URL_TIBASE+id+key;
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
          print(values[i]["TIBaseID"]);
          //if(values[i]["SpeedKnot"] == 0) {
          Map<String, dynamic> map = values[i];
          _postList.add(TiBaseModel.fromJson(map));
          print(
              "mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
          //}
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

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

//State
class MapSampleState extends State<HomePage> {
  Completer<GoogleMapController> _Controller = Completer();

  static const LatLng _center =
      const LatLng(20.845724105834961, 106.71234893798828);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition0 = _center;
  MapType _currentMaptype = MapType.satellite;

  _onMapCreated(GoogleMapController controller) {
    _Controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition0 = position.target;
  }

  _showListShip1() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('ListView in Dialog'),
            content: Container(
              width: double.maxFinite,
              height: 300.0,
              child: ListTile(
                title: Text("aaaaaaaaa"),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  final _debouncer = Debouncer(milliseconds: 500);
  void _showListShip() {
    List<TiBaseModel> _postListS = new List<TiBaseModel>();
    _postListS = _postList;
    print(_postList.length);
    int ShipCount = _postList.length;
    Dialog dialogWithImage = Dialog(
      child: Container(
        height: 450.0,
        width: 200.0,
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Hiện tại có $ShipCount tàu',
              ),
              onChanged: (string) {
                _debouncer.run(() {
                  setState(() {
                    _postListS = _postList
                        .where((u) => (u.ShipName.toLowerCase()
                                .contains(string.toLowerCase()) ||
                            u.ShipName.toLowerCase()
                                .contains(string.toLowerCase())))
                        .toList();
                  });
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: _postListS.length,
                itemBuilder: (BuildContext context, int index) {
                  print(_postListS[index].ShipName);
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              showCustomDialogWithImage(_postListS[index]);
                            },
                            child: Text(
                              _postListS[index].ShipName,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            _postListS[index].Coordinate.toString(),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => dialogWithImage);
  }

  void showCustomDialogWithImage(TiBaseModel Post) {
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
                    'Chủ tàu', //                              <--- text
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    Post.Fullname, //                              <--- text
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
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
                    Post.SpeedKnot +" knot" + " ("+ Post.Speed.toString() +" km/h)"
                        .toString(), //                              <--- text
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
                    Post.Coordinate
                        .toString(), //                              <--- text
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


  BitmapDescriptor get deliveryIcon {
    return BitmapDescriptor.fromAsset('assets/ship-move.png');
  }

  //BitmapDescriptor myIcon;
  //@override
  //void initState() {
    //BitmapDescriptor.fromAssetImage(
        //ImageConfiguration(size: Size(8, 8)), 'assets/ship-move-1.png').then((onValue) {
     // myIcon = onValue;
    //});
  //}
  void setStateMaker(AuthModel _auth) async {
    _postList = new List<TiBaseModel>();
    fetchTiBaseModel3(_auth);
    print(
        "================================================================================");
    print(_postList.length);

    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        for (var i = 0; i < _postList.length; i++) {
          TiBaseModel Post = new TiBaseModel();
          Post = _postList[i];

          double Lat = _postList[i].Lt;
          double Lon = _postList[i].Ln;
          LatLng _center2 = LatLng(Lat, Lon);
          LatLng _lastMapPosition = _center2;

          _markers.add(Marker(
              markerId: MarkerId(_lastMapPosition.toString()),
              position: _lastMapPosition,
              //infoWindow: InfoWindow(title: _postList[i].ShipName, snippet: ""),
              infoWindow: InfoWindow(title: _postList[i].ShipName),
              //icon: BitmapDescriptor.defaultMarker,
              icon: deliveryIcon,
              //icon:myIcon,
              onTap: () {
                //_showDialog(Post);
                showCustomDialogWithImage(Post);
              }
              //icon:_setSourceIcon,
              ));
          print("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
          print(_postList[i].ShipName);
        }
      });
      // })
    });
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);
    setStateMaker(_auth);
    //_auth?.user?.firstname.toString() ?? "",
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Giám sát tàu cá",
          textScaleFactor: textScaleFactor,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _showListShip,
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          )
        ],
      ),
      drawer: AppDrawer(),

      // ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 7.0,
            ),
            mapType: _currentMaptype,
            markers: _markers,
            onCameraMove: _onCameraMove,
          )
        ],
      ),
    );
  }
}

