import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:login/constants.dart';
import 'package:login/data/models/auth.dart';
import 'package:flutter_whatsnew/flutter_whatsnew.dart';
import 'package:login/ui/blue/ChatPage.dart';
import 'package:login/ui/blue/SelectBondedDevicePage.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);
    return Drawer(
      child: SafeArea(
        // color: Colors.grey[50],
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(
                //_auth.user.firstname + " " + _auth.user.lastname,
                _auth.user.firstname,
                textScaleFactor: textScaleFactor,
                maxLines: 1,
              ),
              //subtitle: Text(
                //_auth.user.id.toString(),
               // textScaleFactor: textScaleFactor,
                //maxLines: 1,
              //),
              // onTap: () {
              //   Navigator.of(context).popAndPushNamed("/myaccount");
              // },
            ),
            Divider(height: 5.0),
//            ListTile(
//              leading: Icon(Icons.info),
//              title: Text(
//                "What's New",
//                textScaleFactor: textScaleFactor,
//              ),
//              onTap: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => WhatsNewPage.changelog(
//                      title: Text(
//                        "What's New",
//                        textScaleFactor: textScaleFactor,
//                        textAlign: TextAlign.center,
//                        style: TextStyle(
//                          fontSize: 22.0,
//                          fontWeight: FontWeight.bold,
//                        ),
//                      ),
//                      buttonText: Text(
//                        'Continue',
//                        textScaleFactor: textScaleFactor,
//                        style: TextStyle(
//                          color: Colors.white,
//                        ),
//                      ),
//                    ),
//                    fullscreenDialog: true,
//                  ),
//                );
//              },
//            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Cài đặt',
                textScaleFactor: textScaleFactor,
              ),
              onTap: () {
                Navigator.of(context).popAndPushNamed("/settings");
              },
            ),
            Divider(height: 1.0),
            ListTile(
              leading: Icon(Icons.bluetooth),
              title: Text(
                'Bluetooths',
                textScaleFactor: textScaleFactor,
              ),
              onTap: () {
                Navigator.of(context).popAndPushNamed("/bluetooth");
              },
            ),
            Divider(height: 1.0),
            ListTile(
              leading: Icon(Icons.message),
              title: Text(
                'Nhắn tin',
                textScaleFactor: textScaleFactor,
              ),
              onTap: () async {
                final BluetoothDevice selectedDevice =
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SelectBondedDevicePage(checkAvailability: false);
                    },
                  ),
                );

                if (selectedDevice != null) {
                  print('Connect -> selected ' + selectedDevice.address);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return ChatPage(server: selectedDevice);
                    },
                  ));
                } else {
                  print('Connect -> no device selected');
                }
              },
            ),
            Divider(height: 1.0),
            ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text(
                'Đăng xuất',
                textScaleFactor: textScaleFactor,
              ),
              onTap: () => _auth.logout(),
            ),
          ],
        ),
      ),
    );
  }
}
