import 'package:notes_app/data/model/notes_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static Future<Database> initDatabase() async{
    // get database path
    var dbPath = await getDatabasesPath();
    String path = join(dbPath,'my_notes.db');

    // open database
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async{
    String sql = '''
    CREATE TABLE notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      content TEXT,
      color TEXT,
      dateTime TEXT,
    )
    ''';
    await db.execute(sql);
  }

  // write data.........
  static Future<int> insertNote(NoteModel noteModel) async{
    Database db = await DatabaseHelper.initDatabase();
    return await db.insert('notes', noteModel.toMap());
  }

  // read data.........
  static Future<List<NoteModel>> getNote() async{
    Database db = await DatabaseHelper.initDatabase();
    var note = await db.query('notes');
    List<NoteModel> noteList = note.isNotEmpty
                                ? note.map((e) => NoteModel.fromMap(e)).toList()
                                : [];
    return noteList;
  }

  // update data.........
  static Future<int> updateNote(NoteModel noteModel) async{
    Database db = await DatabaseHelper.initDatabase();
    return await db.update('notes', noteModel.toMap(), where: 'id=?', whereArgs: [noteModel.id]);
  }

  // deleted data.........
  static Future<int> deletedNote(int id) async{
    Database db = await DatabaseHelper.initDatabase();
    return await db.delete('notes', where: 'id=?', whereArgs: [id]);
  }

}