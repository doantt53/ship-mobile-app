import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:login/ui/blue/ChatPage.dart';
import 'package:login/ui/blue/SelectBondedDevicePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './HelperFunctions.dart';

class SmsButton extends StatelessWidget {
  const SmsButton({Key key, @required this.phoneNumbers}) : super(key: key);

  final Iterable phoneNumbers;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.message),
      onPressed: onSmsButtonPressed(context),
    );
  }

  Function onSmsButtonPressed(BuildContext context) {
    String number = HelperFunctions.getValidPhoneNumber(phoneNumbers);
    if (number != null) {
      return () async {
        number = number.replaceAll(RegExp(r"[^\w]"), "");
        print(number);

        // Store phone number receive
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString("phone_number_receive", number);
        });

        final BluetoothDevice selectedDevice = await Navigator.of(context).push(
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
      };
    } else {
      return null;
    }
  }
}
