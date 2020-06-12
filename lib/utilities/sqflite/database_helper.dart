import 'dart:io';

import 'package:gogamedemo/database/model_class/contact.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;

  static Database _database;
  String contactTable = 'contact_table';
  String colId = 'id';
  String colName = 'name';
  String colMobile = 'mobile';
  String colEmail = 'email';
  String colImage = 'image';
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'contact.db';

    var contactDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return contactDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $contactTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT NOT NULL,$colMobile TEXT NOT NULL,$colEmail TEXT,$colImage TEXT)');
  }

  Future<List<Map<String, dynamic>>> getContactMapList() async {
    Database db = await this.database;
    var result = db.query(contactTable, orderBy: '$colName ASC');
    return result;
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await this.database;
    var result = db.insert(contactTable, contact.toMap());
    return result;
  }

  Future<int> updateContact(Contact contact) async {
    Database db = await this.database;
    var result = db.update(contactTable, contact.toMap(),
        where: '$colId = ?', whereArgs: [contact.id]);
    return result;
  }

  Future<int> deleteContact(int id) async {
    Database db = await this.database;
    var result = db.delete(contactTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> count =
        await db.rawQuery('SELECT COUNT(*) from $contactTable');
    int result = Sqflite.firstIntValue(count);
    return result;
  }

  Future<List<Contact>> getContactList() async {
    var contactMapList =
        await getContactMapList(); // Get 'Map List' from database
    int count =
        contactMapList.length; // Count the number of map entries in db table

    List<Contact> noteList = List<Contact>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Contact.fromMapObject(contactMapList[i]));
    }

    return noteList;
  }
}
