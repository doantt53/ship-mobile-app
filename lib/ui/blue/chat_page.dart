import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ship/data/models/message.dart';
import 'package:ship/data/models/message_detail.dart';
import 'package:ship/ui/contacts/contacts_page.dart';
import 'package:ship/utils/database_helper.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice device;

  int msgId;

  String displayName;

  ChatPage(this.device, this.msgId, this.displayName);

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  DatabaseHelper db = new DatabaseHelper();

  List<MessageDetail> messages = List<MessageDetail>();

  int msgId;

  String displayName;

  String phoneNumber = "";

  static final clientID = 0;

  BluetoothDevice device;

  BluetoothCharacteristic blueCharacteristic;

  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();

  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = false;

  bool isConnected = true;

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    this.device = widget.device;

    this.msgId = widget.msgId;
    this.displayName = widget.displayName;

    // Get all message
    db.getMessageDetailWithMsgId(this.msgId).then((notes) {
      setState(() {
        notes.forEach((note) {
          messages.add(MessageDetail.fromMap(note));
        });
      });
    });

    if (this.msgId < 0 && this.displayName.length == 0) {
      isConnected = false;
    }
    print("msgId = $msgId");

    getBluetoothCharacteristic();
  }

//  @override
//  void initState() {
//    super.initState();

//    SharedPreferences.getInstance().then((prefs) {
//      _phone_number = prefs.getString("phone_number_receive") ?? "";
//      print("_ChatPage => $_phone_number");
//    });
//
//    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
//      print('Connected to the device');
//      connection = _connection;
//      setState(() {
//        isConnecting = false;
//        isDisconnecting = false;
//      });

//      connection.input.listen(_onDataReceived).onDone(() {
//        // Example: Detect which side closed the connection
//        // There should be `isDisconnecting` flag to show are we are (locally)
//        // in middle of disconnecting process, should be set before calling
//        // `dispose`, `finish` or `close`, which all causes to disconnect.
//        // If we except the disconnection, `onDone` should be fired as result.
//        // If we didn't except this (no flag set), it means closing by remote.
//        if (isDisconnecting) {
//          print('Disconnecting locally!');
//        } else {
//          print('Disconnected remotely!');
//        }
//        if (this.mounted) {
//          setState(() {});
//        }
//      });
//    }).catchError((error) {
//      print('Cannot connect, exception occured');
//      print(error);
//    });
//  }

//  @override
//  void dispose() {
//    // Avoid memory leak (`setState` after dispose) and disconnect
//    if (isConnected) {
//      isDisconnecting = true;
//      connection.dispose();
//      connection = null;
//    }
//
//    super.dispose();
//  }

//  @override
//  void initState() {
//    super.initState();
//
////    _titleController = new TextEditingController(text: widget.note.name);
////    _descriptionController = new TextEditingController(text: widget.note.message);
//  }

  @override
  Widget build(BuildContext context) {
    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.message.trim()),
                style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color: _message.msgIn == 0 ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.msgIn == 0
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(this.displayName),
//          title: (isConnecting
//              ? Text('Connecting chat to ' + widget.server.name + '...')
//              : isConnected
//              ? Text('Tin nhắn: ' + _phone_number)
//              : Text('Chat log with ' + widget.server.name)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                final PermissionStatus permissionStatus =
                    await _getPermission();
                if (permissionStatus == PermissionStatus.granted) {
                  Contact selected = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ContactsPage(title: 'Flutter Contacts')));
                  if (selected != null) {
                    this.displayName = selected.displayName;
                    this.phoneNumber = selected.phones
                        .elementAt(0)
                        .value
                        .replaceAll(RegExp(r"[^\w]"), "");
                    print("SĐT: $phoneNumber");
                    setState(() {
                      isConnected = true;
                    });
                  }
                }

//                String number = selected.phones
//                    .elementAt(0)
//                    .value
//                    .replaceAll(RegExp(r"[^\w]"), "");
//                print("Data: $number");
//                print("Data: {$selected.displayName}");

//                final PermissionStatus permissionStatus =
//                    await _getPermission();
//                if (permissionStatus == PermissionStatus.granted) {
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => ContactsPage()));
//                } else {
//                  //If permissions have been denied show standard cupertino alert dialog
//                  showDialog(
//                      context: context,
//                      builder: (BuildContext context) => CupertinoAlertDialog(
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
            )
          ]),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView(
                  padding: const EdgeInsets.all(12.0),
                  controller: listScrollController,
                  children: list),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: TextField(
                      style: const TextStyle(fontSize: 15.0),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: isConnecting
                            ? 'Đang kết nối bluetooth ...'
                            : isConnected
                                ? 'Tin nhắn không quá 76 ký tự ...'
                                : 'Không thể gửi tin nhắn',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      enabled: isConnected,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        _sendMessage(textEditingController.text);
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
//        MessageDetail
//        messages.add(
//          _Message(
//            1,
//            backspacesCounter > 0
//                ? _messageBuffer.substring(
//                0, _messageBuffer.length - backspacesCounter)
//                : _messageBuffer + dataString.substring(0, index),
//          ),
//        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        String send = "\$MES_$phoneNumber" + "_" + text + "\r\n";
        _sendDataViaBlue(send);

        if (this.msgId < 0) {
          Message msg = await db.getMessageWithName(this.displayName);
          print(msg);
          if (msg == null) {
            int id = await db.saveMessage(Message(this.displayName, text));
            this.msgId = id;
          } else {
            this.msgId = msg.id;
          }
        }

        await db.saveMessageDetail(
            MessageDetail(this.msgId, this.displayName, text, 0));

        setState(() {
          messages.add(MessageDetail(this.msgId, this.displayName, text, 0));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted) {
      final Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  getBluetoothCharacteristic() async {
    final mtu = await device.mtu.first;
    await device.requestMtu(180);
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      List<BluetoothCharacteristic> blueChar = service.characteristics;
      blueChar.forEach((f) async {
        if (f.uuid.toString().startsWith("0000ffe2", 0) == true) {
          this.blueCharacteristic = f;
        }
      });
    });
  }

//  _sendDataViaBlue(String text) async {
//    List<BluetoothService> services = await device.discoverServices();
//    services.forEach((service) {
//      List<BluetoothCharacteristic> blueChar = service.characteristics;
//      blueChar.forEach((f) async {
//        if (f.uuid.toString().startsWith("0000ffe2", 0) == true) {
////          await f.write(utf8.encode(text), withoutResponse: true);
//          await f.write(utf8.encode("\$MES_cong hoa xa hoi chu nghia viet nam"), withoutResponse: true);
//          print("Characteristice =  ${f.uuid}, data = $text");
//        }
//      });
//    });
//  }

  _sendDataViaBlue(String text) async {
    if(blueCharacteristic != null) {
      await blueCharacteristic.write(utf8.encode(text));
      print(text);
    }
  }
}
