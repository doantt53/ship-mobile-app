import 'dart:async';

import 'package:ship/data/models/ContactShip.dart';
import 'package:ship/data/models/message.dart';
import 'package:ship/data/models/message_detail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  // Table Message
  final String tableMessage = 'messageTable';
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnMessage = 'message';

  // Table Message
  final String tableMessageDetail = 'messageDetailTable';
  final String columnMsgId = 'msgId';
  final String columnMsgIn = 'msgIn';

  // Table ContactShip
  final String tableContactShip = 'messageContactShip';
  final String columnContactID = 'contactID';
  final String columnDeviceID = 'deviceID';
  final String columnCode = 'code';
  final String columnPhone = 'phone';
  final String columnDateCreate = 'dateCreate';


  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'messages.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    // Create table messageTable
    await db.execute(
        'CREATE TABLE $tableMessage($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnMessage TEXT)');

    // Create table message detail table
    await db.execute(
        'CREATE TABLE $tableMessageDetail($columnId INTEGER PRIMARY KEY, $columnMsgId INTEGER, $columnName TEXT, $columnMessage TEXT, $columnMsgIn INTEGER)');

    // Create table ContactShip
    await db.execute(
        'CREATE TABLE $tableContactShip($columnId INTEGER PRIMARY KEY, $columnContactID INTEGER, $columnDeviceID INTEGER, $columnCode INTEGER, $columnPhone TEXT, $columnDateCreate TEXT, $columnName TEXT)');

  }

  Future<int> saveMessage(Message note) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableMessage, note.toMap());
//    var result = await dbClient.rawInsert(
//        'INSERT INTO $tableNote ($columnTitle, $columnDescription) VALUES (\'${note.title}\', \'${note.description}\')');

    return result;
  }

  Future<List> getAllMessages() async {
    var dbClient = await db;
    var result = await dbClient.query(tableMessage, columns: [columnId, columnName, columnMessage]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableNote');

    return result.toList();
  }

  Future<int> getCountMessages() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableMessage'));
  }

  Future<Message> getMessage(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableMessage,
        columns: [columnId, columnName, columnMessage],
        where: '$columnId = ?',
        whereArgs: [id]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableNote WHERE $columnId = $id');

    if (result.length > 0) {
      return new Message.fromMap(result.first);
    }

    return null;
  }

  Future<Message> getMessageWithName(String displayName) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableMessage,
        columns: [columnId, columnName, columnMessage],
        where: '$columnName = ?',
        whereArgs: [displayName]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableNote WHERE $columnId = $id');

    if (result.length > 0) {
      return new Message.fromMap(result.first);
    }
    return null;
  }


  Future<int> deleteMessage(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableMessage, where: '$columnId = ?', whereArgs: [id]);
//    return await dbClient.rawDelete('DELETE FROM $tableNote WHERE $columnId = $id');
  }

  Future<int> updateMessage(Message note) async {
    var dbClient = await db;
    return await dbClient.update(tableMessage, note.toMap(), where: "$columnId = ?", whereArgs: [note.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE $tableNote SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<int> saveMessageDetail(MessageDetail _msgDetail) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableMessageDetail, _msgDetail.toMap());
    return result;
  }

  Future<List> getAllMessageDetails() async {
    var dbClient = await db;
    var result = await dbClient.query(tableMessageDetail, columns: [columnId, columnMsgId, columnName, columnMessage, columnMsgIn]);
    return result.toList();
  }

  Future<List> getMessageDetailWithMsgId(int _msgId) async {
    var dbClient = await db;
    var result = await dbClient.query(tableMessageDetail,
        columns: [columnId, columnMsgId, columnName, columnMessage, columnMsgIn],
        where: '$columnMsgId = ?',
        whereArgs: [_msgId]);
    return result.toList();
  }

  Future<int> getCountMessageDetails() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableMessageDetail'));
  }

  Future<Message> getMessageDetailWithId(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableMessage,
        columns: [columnId, columnMsgId, columnName, columnMessage, columnMsgIn],
        where: '$columnId = ?',
        whereArgs: [id]);

    if (result.length > 0) {
      return new Message.fromMap(result.first);
    }

    return null;
  }

//  Future<int> deleteMessageDetail(int id) async {
//    var dbClient = await db;
//    return await dbClient.delete(tableMessage, where: '$columnId = ?', whereArgs: [id]);
////    return await dbClient.rawDelete('DELETE FROM $tableNote WHERE $columnId = $id');
//  }
//
//  Future<int> updateMessageDetail(Message note) async {
//    var dbClient = await db;
//    return await dbClient.update(tableMessage, note.toMap(), where: "$columnId = ?", whereArgs: [note.id]);
////    return await dbClient.rawUpdate(
////        'UPDATE $tableNote SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}');
//  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<int> saveContactDetail(ContactShip _contact) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableContactShip, _contact.toMap());
    return result;
  }

  Future<List> getAllContacts() async {
    var dbClient = await db;
    var result = await dbClient.query(tableContactShip, columns: [columnId, columnContactID, columnDeviceID, columnCode, columnPhone, columnDateCreate, columnName]);
    return result.toList();
  }

  Future<int> deleteAllContacts() async {
    var dbClient = await db;
    return await dbClient.delete(tableContactShip);
  }

  Future<int> getCountContacts() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableContactShip'));
  }

//  Future<List> getDetailContact(String _name) async {
//    var dbClient = await db;
//    var result = await dbClient.query(tableMessageDetail,
//        columns: [columnId, columnContactID, columnDeviceID, columnCode, columnPhone, columnDateCreate, columnName],
//        where: '$columnName = ?',
//        whereArgs: [_msgId]);
//    return result.toList();
//  }
//
//  Future<int> getCountMessageDetails() async {
//    var dbClient = await db;
//    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableMessageDetail'));
//  }

  Future<ContactShip> getContactShipDetailWithName(String name) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableContactShip,
        columns: [columnId, columnContactID, columnDeviceID, columnCode, columnPhone, columnDateCreate, columnName],
        where: '$columnName = ?',
        whereArgs: [name]);

    if (result.length > 0) {
      return new ContactShip.fromMap(result.first);
    }

    return null;
  }
}
