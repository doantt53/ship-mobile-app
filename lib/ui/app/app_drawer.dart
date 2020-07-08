import 'package:flutter/material.dart';
import 'package:ship/ui/blue/blue_page.dart';
import 'package:ship/ui/blue/bluetooth.dart';
import 'package:ship/ui/contacts/add_date.dart';
import 'package:ship/ui/contacts/contacts_pages_ship.dart';
import 'package:ship/ui/lockedscreen/JourneysPage.dart';
import 'package:ship/ui/lockedscreen/MonutorPage.dart';
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
                _auth.user.firstname,
                textScaleFactor: textScaleFactor,
                maxLines: 1,
              ),
            ),
            Divider(height: 5.0),
            ListTile(
              leading: Icon(Icons.gps_fixed),
              title: Text(
                'Giám sát tàu',
                textScaleFactor: textScaleFactor,
              ),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return monitorPage();
                    },
                  ),
                );
              },
            ),
            Divider(height: 5.0),
            ListTile(
              leading: Icon(Icons.history),
              title: Text(
                'Xem hành trình',
                textScaleFactor: textScaleFactor,
              ),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return journeysPage();
                    },
                  ),
                );
              },
            ),

            Divider(height: 1.0),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(
                'Danh bạ',
                textScaleFactor: textScaleFactor,
              ),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ContactsShipPage(true);
                    },
                  ),
                );
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
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return BlueDevicesScreen(true);
                    },
                  ),
                );
              },
            ),
            Divider(height: 5.0),
            ListTile(
              leading: Icon(Icons.turned_in),
              title: Text(
                'Số tin đã nhắn',
                textScaleFactor: textScaleFactor,
              ),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AddDate();
                    },
                  ),
                );
              },
            ),
            Divider(height: 5.0),

            Divider(height: 5.0),
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
