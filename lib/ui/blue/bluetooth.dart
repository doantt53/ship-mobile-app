// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'listview_message.dart';
import 'widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

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

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bluetooth")),
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Vui lòng kết nối Bluetooth với thiết bị định vị Tàu cá.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  final bool isLogin;

  FindDevicesScreen(this.isLogin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm thiết bị'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map((d) => ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  // Next screen chat
//                                  Navigator.of(context).pushReplacement(
//                                      new MaterialPageRoute(
//                                          builder: (BuildContext context) =>
//                                              ListViewNote(device: d)));

//                                  Navigator.of(context).push(MaterialPageRoute(
//                                      builder: (context) =>
//                                          ListViewNote(device: d)));

                                  return RaisedButton(
                                      child: Text('Mở'),
                                      onPressed: () {
//                                      Navigator
////                                          .of(context)
////                                          .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => ListViewNote(device: d)));

                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ListViewMessage(
                                                        isLogin, d)));

                                        FlutterBlue.instance.stopScan();
                                      }

//                                    => Navigator.of(context).push(
//                                        MaterialPageRoute(
//                                            builder: (context) =>
//                                                DeviceScreen(device: d))),

                                      );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => ScanResultTile(
                            result: r,
                            onTap: () async {
                              await r.device.connect();

//                              Navigator.of(context)
//                                  .push(MaterialPageRoute(builder: (context) {
//                                r.device.connect();
//                                return ListViewMessage(isLogin, r.device);
//                              }));
//
//                              FlutterBlue.instance.stopScan();
                            }
//                          => Navigator.of(context)
//                              .push(MaterialPageRoute(builder: (context) {
//                            r.device.connect();
//                            return DeviceScreen(device: r.device);
//                          })),
                            ),
                      )
                      .toList(),
                ),
              ),
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
                    .startScan(timeout: Duration(seconds: 4)));
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
