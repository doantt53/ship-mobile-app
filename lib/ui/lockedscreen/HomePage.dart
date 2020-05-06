import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../data/models/auth.dart';
import '../app/app_drawer.dart';

class HomePage extends StatelessWidget {

  Completer<GoogleMapController> _Controller = Completer();

  static const LatLng _center =
  const LatLng(20.845724105834961, 106.71234893798828);
  static const LatLng _center1 =
  const LatLng(20.845735549926758, 106.71233367919922);
  static const LatLng _center2 = const LatLng(20.842907, 106.709155);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition0 = _center;
  LatLng _lastMapPosition1 = _center1;
  LatLng _lastMapPosition2 = _center2;
  MapType _currentMaptype = MapType.normal;


  _onMapCreated(GoogleMapController controller) {
    _Controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition0 = position.target;
  }


  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          textScaleFactor: textScaleFactor,
        ),
        actions: <Widget>[
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
