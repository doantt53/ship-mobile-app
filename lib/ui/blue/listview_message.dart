import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:ship/data/models/message.dart';
import 'package:ship/utils/database_helper.dart';
import 'chat_page.dart';
import 'note_screen.dart';

class ListViewMessage extends StatefulWidget {
  final BluetoothDevice device;

  ListViewMessage({this.device});

  @override
  _ListViewMessageState createState() => new _ListViewMessageState();
}

class _ListViewMessageState extends State<ListViewMessage> {
  List<Message> items = new List();
  DatabaseHelper db = new DatabaseHelper();

  @override
  void initState() {
    super.initState();

    db.getAllMessages().then((notes) {
      setState(() {
        notes.forEach((note) {
          items.add(Message.fromMap(note));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSA ListView Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Danh sách tin nhắn'),
//          centerTitle: true,
//          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                String img = items[position].name.substring(0, 1);
                String des = items[position].message;
                if (des.length > 70) {
                  des = items[position].message.substring(0, 70);
                  print("==> " + des);
                }
                return Column(
                  children: <Widget>[
                    ListTile(
                        title: Text('${items[position].name}'),
                        subtitle: Text(des),
                        leading: CircleAvatar(
                          child: Text(img),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(widget.device,
                                    items[position].id, items[position].name)),
                          );
//                        _navigateToNote(context, items[position]);
                        }),
                    Divider(height: 5.0),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage(widget.device, -1, "")),
            );

//            Navigator.of(context).pushReplacement(new MaterialPageRoute(
//                builder: (BuildContext context) => ChatPage(-1, "")));

//            Navigator
//                .of(_context)
//                .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => page));

//    => _createNewNote(context)
          },
        ),
      ),
    );
  }

  void _deleteNote(BuildContext context, Message note, int position) async {
    db.deleteMessage(note.id).then((notes) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToNote(BuildContext context, Message note) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(note)),
    );

    if (result == 'update') {
      db.getAllMessages().then((notes) {
        setState(() {
          items.clear();
          notes.forEach((note) {
            items.add(Message.fromMap(note));
          });
        });
      });
    }
  }

  void _createNewNote(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(Message('', ''))),
    );

    if (result == 'save') {
      db.getAllMessages().then((notes) {
        setState(() {
          items.clear();
          notes.forEach((note) {
            items.add(Message.fromMap(note));
          });
        });
      });
    }
  }
}
