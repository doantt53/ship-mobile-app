// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ship/utils/database_helper.dart';

import 'chat_page.dart';
import 'listview_message.dart';
import 'widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;

//void main() {
//  runApp(FlutterBlueApp());
//}

//class FlutterBlueApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      color: Colors.lightBlue,
//      home: StreamBuilder<BluetoothState>(
//          stream: FlutterBlue.instance.state,
//          initialData: BluetoothState.unknown,
//          builder: (c, snapshot) {
//            final state = snapshot.data;
//            if (state == BluetoothState.on) {
//              return FindDevicesScreen();
//            }
//            return BluetoothOffScreen(state: state);
//          }),
//    );
//  }
//}

//class BluetoothOffScreen extends StatelessWidget {
//  const BluetoothOffScreen({Key key, this.state}) : super(key: key);
//
//  final BluetoothState state;
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(title: Text("Bluetooth")),
//      backgroundColor: Colors.lightBlue,
//      body: Center(
//        child: Column(
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            Icon(
//              Icons.bluetooth_disabled,
//              size: 200.0,
//              color: Colors.white54,
//            ),
//            Text(
//              'Vui lòng kết nối Bluetooth với thiết bị định vị Tàu cá.',
//              style: Theme.of(context)
//                  .primaryTextTheme
//                  .subhead
//                  .copyWith(color: Colors.white),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}

//class BlueDevicesScreen extends StatelessWidget {
class BlueDevicesScreen extends StatefulWidget {
  final bool isLogin;
  BlueDevicesScreen(this.isLogin);

  @override
  State<StatefulWidget> createState() => new _BlueDevicesScreen();
}

class _BlueDevicesScreen extends State<BlueDevicesScreen> {
  DatabaseHelper db = new DatabaseHelper();

  int cntMsg = 0;

  bool isLogin;

  FlutterBlue flutterBlue = FlutterBlue.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    this.isLogin = widget.isLogin;
    db.getCountMessages().then((notes) {
      this.cntMsg = notes;
    });


    flutterBlue.startScan(timeout: Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Tìm thiết bị'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 10)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map((d) => ListTile(
                            title: Text(d.device.name),
                            subtitle: Text(d.device.id.toString()),
                            leading: Icon(Icons.bluetooth),
                            onTap: () async {
                              print(d.device.id.toString());
                              final snackBar = SnackBar(
                                duration: Duration(seconds: 60),
                                content: Row(
                                  children: <Widget>[
                                    CircularProgressIndicator(),
                                    Text(
                                        "  Đang kết nối bluetooth ${d.device.name} ")
                                  ],
                                ),
                              );
                              _scaffoldKey.currentState.showSnackBar(snackBar);
                              try {
                                await d.device.connect();
                              } on Exception catch (_) {
                                print("Blue connect error");
                              }

                              final state = (d.device.state).firstWhere(
                                  (s) => s == BluetoothDeviceState.connected);
                              if (state != null) {
                                print("Đã kết thành công blue ${d.device.name}");
                                // Next screen
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ListViewMessage(
                                                isLogin, d.device)));

                                FlutterBlue.instance.stopScan();
                              } else {
                                print("Kết nối thất bại");
                              }
                              _scaffoldKey.currentState.hideCurrentSnackBar();
                            },
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.device.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                return Icon(Icons.link);
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 4))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map((d) => ListTile(
                    title: Text(d.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    subtitle: Text(d.id.toString(), style: TextStyle(color: Colors.blue)),
                    leading: Icon(Icons.bluetooth_connected),
                    onTap: () async {
                      final state = (d.state).firstWhere(
                              (s) => s == BluetoothDeviceState.connected);
                      if(state != null) {
                        if(this.cntMsg > 0) {
                          // Open message
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ListViewMessage(
                                          isLogin, d)));
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => ChatPage(isLogin, d, -1, "", platform == TargetPlatform.iOS ? true : false)),
                          );
                        }

                        FlutterBlue.instance.stopScan();

                        // Check login to store device name.
                        if(this.isLogin) {
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setString("BLUE_TARGET_DEVICE_NAME", d.name);
                          });
                        }
                      }
//                      print(d.id.toString());
//                      final snackBar = SnackBar(
//                        duration: Duration(seconds: 60),
//                        content: Row(
//                          children: <Widget>[
//                            CircularProgressIndicator(),
//                            Text(
//                                "  Đang kết nối bluetooth ${d.device.name} ")
//                          ],
//                        ),
//                      );
//                      _scaffoldKey.currentState.showSnackBar(snackBar);
//                      try {
//                        await d.device.connect();
//                      } on Exception catch (_) {
//                        print("Error");
//                      }
//
//                      final state = (d.device.state).firstWhere(
//                              (s) => s == BluetoothDeviceState.connected);
//                      if (state != null) {
//                        print("Đã kết thành công blue");
//
//                        // Next screen
//
//                      } else {
//                        print("Kết nối thất bại");
//                      }
//                      _scaffoldKey.currentState.hideCurrentSnackBar();
                    },
                    trailing: StreamBuilder<BluetoothDeviceState>(
                      stream: d.state,
                      initialData: BluetoothDeviceState.disconnected,
                      builder: (c, snapshot) {
                        return Icon(Icons.cast_connected);

                      },
                    ),
                  ))
                      .toList(),
                ),


//                builder: (c, snapshot) => Column(
//                  children: snapshot.data
//                      .map((d) => ListTile(
//                    title: Text(d.name),
//                    subtitle: Text(d.id.toString()),
//                    trailing: StreamBuilder<BluetoothDeviceState>(
//                      stream: d.state,
//                      initialData: BluetoothDeviceState.disconnected,
//                      builder: (c, snapshot) {
////                        if (snapshot.data ==
////                            BluetoothDeviceState.connected) {
////                          if (!isLogin) {
//////                                    SharedPreferences _prefs = await SharedPreferences.getInstance();
//////                                    String sUserId = _prefs.getString("saved_user_id") ?? "";
////                            // Check open message
////                            if(d.name != null && d.name.length > 0 && d.name.startsWith("BK")) {
////                              Navigator.of(context).push(
////                                  MaterialPageRoute(
////                                      builder: (context) =>
////                                          ListViewMessage(
////                                              isLogin, d)));
////
////                              FlutterBlue.instance.stopScan();
////                            }
////                          }
//                          // Next screen chat
////                                  Navigator.of(context).pushReplacement(
////                                      new MaterialPageRoute(
////                                          builder: (BuildContext context) =>
////                                              ListViewNote(device: d)));
//
////                                  Navigator.of(context).push(MaterialPageRoute(
////                                      builder: (context) =>
////                                          ListViewNote(device: d)));
//
////                          return RaisedButton(
////                              child: Text('Mở'),
////                              onPressed: () {
////                                Navigator.of(context).push(
////                                    MaterialPageRoute(
////                                        builder: (context) =>
////                                            ListViewMessage(
////                                                isLogin, d)));
////
////                                FlutterBlue.instance.stopScan();
////                              });
//                        }
//                      },
//                    ),
//                  ))
//                      .toList(),
//                ),
              ),


//              StreamBuilder<List<ScanResult>>(
//                stream: FlutterBlue.instance.scanResults,
//                initialData: [],
//                builder: (c, snapshot) => Column(
//                  children: snapshot.data
//                      .map(
//                        (r) => ScanResultTile(
//                            result: r,
//                            onTap: () async {
//                              await r.device.connect();
//
////                              Navigator.of(context)
////                                  .push(MaterialPageRoute(builder: (context) {
////                                r.device.connect();
////                                return ListViewMessage(isLogin, r.device);
////                              }));
////
////                              FlutterBlue.instance.stopScan();
//                            }
////                          => Navigator.of(context)
////                              .push(MaterialPageRoute(builder: (context) {
////                            r.device.connect();
////                            return DeviceScreen(device: r.device);
////                          })),
//                            ),
//                      )
//                      .toList(),
//                ),
//              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 10)));
          }
        },
      ),
    );
  }
}

//class DeviceScreen extends StatelessWidget {
//  const DeviceScreen({Key key, this.device}) : super(key: key);
//
//  final BluetoothDevice device;
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(title: Text(device.name), actions: <Widget>[
//        StreamBuilder<BluetoothDeviceState>(
//          stream: device.state,
//          initialData: BluetoothDeviceState.connecting,
//          builder: (c, snapshot) {
//            VoidCallback onPressed;
//            String text;
//            switch (snapshot.data) {
//              case BluetoothDeviceState.connected:
//                onPressed = () => device.disconnect();
//                text = 'DISCONNECT';
//                break;
//              case BluetoothDeviceState.disconnected:
//                onPressed = () => device.connect();
//                text = 'CONNECT';
//                break;
//              default:
//                onPressed = null;
//                text = snapshot.data.toString().substring(21).toUpperCase();
//                break;
//            }
//            return FlatButton(
//                onPressed: onPressed,
//                child: Text(
//                  text,
//                  style: Theme.of(context)
//                      .primaryTextTheme
//                      .button
//                      .copyWith(color: Colors.white),
//                ));
//          },
//        )
//      ]),
//      body: Center(
//        child: Text('Hello World'),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () async {
//          List<BluetoothService> services = await device.discoverServices();
//          services.forEach((service) {
//            List<BluetoothCharacteristic> blueChar = service.characteristics;
//            blueChar.forEach((f) async {
//              if (f.uuid.toString().startsWith("0000ffe2", 0) == true ||
//                  f.uuid.toString().startsWith("0000ffe1", 0) == true) {
//                await f.write(utf8.encode("\$MES_0973708251_Cong hoa xa hoi"),
//                    withoutResponse: true);
//                print("Characteristice =  ${f.uuid}");
//              }
//            });
//          });
//        },
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ),
//    );
//  }
//}
