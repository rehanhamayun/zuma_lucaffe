import 'package:coffe_qr/database/db_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'example.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  void _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT
      )
    ''');
  }

  Future<List<Contact>> getContacts() async {
    final db = await instance.database;
    final contacts = await db.query('contacts');
    return contacts.map((json) => Contact.fromJson(json)).toList();
  }

  Future<Contact> getContact(int id) async {
    final db = await instance.database;
    final contact = await db.query('contacts', where: 'id = ?', whereArgs: [id]);
    return Contact.fromJson(contact.first);
  }

  Future<int> insertContact(Contact contact) async {
    final db = await instance.database;
    return await db.insert('contacts', contact.toJson());
  }

  Future<int> updateContact(Contact contact) async {
    final db = await instance.database;
    return await db.update('contacts', contact.toJson(),
        where: 'id = ?', whereArgs: [contact.id]);
  }

  Future<int> deleteContact(int id) async {
    final db = await instance.database;
    return await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
