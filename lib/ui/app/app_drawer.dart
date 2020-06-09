import 'package:flutter/material.dart';
import 'package:ship/ui/blue/bluetooth.dart';
import 'package:ship/ui/lockedscreen/SettingsPage.dart';
import '../../constants.dart';
import '../../data/models/auth.dart';
import 'package:provider/provider.dart';

import 'package:flutter/cupertino.dart';

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
              onTap: () async {
//                Navigator.of(context).popAndPushNamed("/settings");
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SettingsPage();
                    },
                  ),
                );
              },
            ),
            Divider(height: 1.0),
//            ListTile(
//              leading: Icon(Icons.phone),
//              title: Text(
//                'Danh bạ',
//                textScaleFactor: textScaleFactor,
//              ),
//              onTap: () {
//                Navigator.of(context).popAndPushNamed("/contacts");
//              },
//            ),
//            Divider(height: 1.0),
//            ListTile(
//              leading: Icon(Icons.bluetooth),
//              title: Text(
//                'Bluetooths',
//                textScaleFactor: textScaleFactor,
//              ),
//              onTap: () async {
////                Navigator.of(context).popAndPushNamed("/bluetooth");
//                await Navigator.of(context).push(
//                  MaterialPageRoute(
//                    builder: (context) {
//                      return FindDevicesScreen();
//                    },
//                  ),
//                );
//              },
//            ),
//            Divider(height: 1.0),
            ListTile(
              leading: Icon(Icons.message),
              title: Text(
                'Nhắn tin',
                textScaleFactor: textScaleFactor,
              ),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return FindDevicesScreen(true);
                    },
                  ),
                );

//                final BluetoothDevice selectedDevice =
//                await Navigator.of(context).push(
//                  MaterialPageRoute(
//                    builder: (context) {
//                      return SelectBondedDevicePage(checkAvailability: false);
//                    },
//                  ),
//                );
//
//                if (selectedDevice != null) {
//                  print('Connect -> selected ' + selectedDevice.address);
//                  Navigator.of(context).push(MaterialPageRoute(
//                    builder: (context) {
//                      return ChatPage(server: selectedDevice);
//                    },
//                  ));
//                } else {
//                  print('Connect -> no device selected');
//                }

//                final PermissionStatus permissionStatus = await _getPermission();
//                if (permissionStatus == PermissionStatus.granted) {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (context) => ContactsPage(title: 'Flutter Contacts')));
//                } else {
//                  //If permissions have been denied show standard cupertino alert dialog
//                  showDialog(
//                      context: context,
//                      builder: (BuildContext context) =>
//                          CupertinoAlertDialog(
//                            title: Text('Permissions error'),
//                            content: Text('Please enable contacts access '
//                                'permission in system settings'),
//                            actions: <Widget>[
//                              CupertinoDialogAction(
//                                child: Text('OK'),
//                                onPressed: () => Navigator.of(context).pop(),
//                              )
//                            ],
//                          ));
//                }
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

//  Future<PermissionStatus> _getPermission() async {
//    final PermissionStatus permission = await PermissionHandler()
//        .checkPermissionStatus(PermissionGroup.contacts);
//    if (permission != PermissionStatus.granted) {
//      final Map<PermissionGroup, PermissionStatus> permissionStatus =
//      await PermissionHandler()
//          .requestPermissions([PermissionGroup.contacts]);
//      return permissionStatus[PermissionGroup.contacts] ??
//          PermissionStatus.unknown;
//    } else {
//      return permission;
//    }
//  }
}
