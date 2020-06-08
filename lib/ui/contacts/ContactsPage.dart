import 'dart:math';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../blue/ChatPage.dart';
import '../blue/SelectBondedDevicePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();
  TextEditingController searchController = new TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    getAllContacts();
    searchController.addListener(() {
      filterContacts();
    });
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  getAllContacts() async {
    List colors = [Colors.green, Colors.indigo, Colors.yellow, Colors.orange];
    int colorIndex = 0;
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    _contacts.forEach((contact) {
      Color baseColor = colors[colorIndex];
      contactsColorMap[contact.displayName] = baseColor;
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
    });
    setState(() {
      contacts = _contacts;
    });
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        var phone = contact.phones.firstWhere((phn) {
          String phnFlattened = flattenPhoneNumber(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);

        return phone != null;
      });

      setState(() {
        contactsFiltered = _contacts;
      });
    }
  }

  _filterContacts(String value) {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (value.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = value.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        var phone = contact.phones.firstWhere((phn) {
          String phnFlattened = flattenPhoneNumber(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);

        return phone != null;
      });

      setState(() {
        contactsFiltered = _contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching3 = searchController.text.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
//        backgroundColor: Colors.pink,
//        title: Text(widget.title),
        title: !isSearching
            ? Text('Liên lạc')
            : TextField(
//          onChanged: (value) {
//            _filterContacts(value);
//            print(value);
//          },
          controller: searchController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: "Tìm liên lạc",
              hintStyle: TextStyle(color: Colors.white)),
        ),
        actions: <Widget>[
          isSearching
              ? IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              setState(() {
                this.isSearching = false;
                contactsFiltered = contacts;
              });
            },
          )
              : IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                this.isSearching = true;
              });
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: contacts.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: isSearching3 == true
                    ? contactsFiltered.length
                    : contacts.length,
                itemBuilder: (context, index) {
                  Contact contact = isSearching3 == true
                      ? contactsFiltered[index]
                      : contacts[index];

                  var baseColor =
                      contactsColorMap[contact.displayName] as dynamic;

                  Color color1 = baseColor[800];
                  Color color2 = baseColor[400];

                  return ListTile(
                      onTap: () async {
                        Contact selected = isSearching3 == true
                            ? contactsFiltered[index]
                            : contacts[index];
                        String number = selected.phones
                            .elementAt(0)
                            .value
                            .replaceAll(RegExp(r"[^\w]"), "");
                        print("Data: $number");

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

                      },
                      title: Text(contact.displayName),
                      subtitle: Text(contact.phones.elementAt(0).value),
                      leading: (contact.avatar != null &&
                              contact.avatar.length > 0)
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(contact.avatar),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                      colors: [
                                        color1,
                                        color2,
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight)),
                              child: CircleAvatar(
                                  child: Text(contact.initials(),
                                      style: TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.transparent)));
                })
            : Center(
                child: CircularProgressIndicator(),
              ),
//        child: Column(
//          children: <Widget>[
//            Container(
//              child: TextField(
//                controller: searchController,
//                decoration: InputDecoration(
//                    labelText: 'Tìm liên lạc',
//                    border: new OutlineInputBorder(
//                        borderSide: new BorderSide(
//                            color: Theme.of(context).primaryColor
//                        )
//                    ),
//                    prefixIcon: Icon(
//                        Icons.search,
//                        color: Theme.of(context).primaryColor
//                    )
//                ),
//              ),
//            ),
//            Expanded(
//              child: ListView.builder(
//                shrinkWrap: true,
//                itemCount: isSearching3 == true ? contactsFiltered.length : contacts.length,
//                itemBuilder: (context, index) {
//                  Contact contact = isSearching3 == true ? contactsFiltered[index] : contacts[index];
//
//                  var baseColor = contactsColorMap[contact.displayName] as dynamic;
//
//                  Color color1 = baseColor[800];
//                  Color color2 = baseColor[400];
//
//                  return ListTile(
//                      onTap: () {
//                        String number = contactsFiltered[index].phones.elementAt(0).value;
//                        number = number.replaceAll(RegExp(r"[^\w]"), "");
//                        print("Data: $number");
//                      },
//                      title: Text(contact.displayName),
//                      subtitle: Text(
//                          contact.phones.elementAt(0).value
//                      ),
//                      leading: (contact.avatar != null && contact.avatar.length > 0) ?
//                      CircleAvatar(
//                        backgroundImage: MemoryImage(contact.avatar),
//                      ) :
//                      Container(
//                          decoration: BoxDecoration(
//                              shape: BoxShape.circle,
//                              gradient: LinearGradient(
//                                  colors: [
//                                    color1,
//                                    color2,
//                                  ],
//                                  begin: Alignment.bottomLeft,
//                                  end: Alignment.topRight
//                              )
//                          ),
//                          child: CircleAvatar(
//                              child: Text(
//                                  contact.initials(),
//                                  style: TextStyle(
//                                      color: Colors.white
//                                  )
//                              ),
//                              backgroundColor: Colors.transparent
//                          )
//                      )
//                  );
//                },
//              ),
//            )
//          ],
//        ),
      ),
    );
  }
}
