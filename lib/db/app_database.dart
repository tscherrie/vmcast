import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class AppDatabase {
  static const int _kVersion = 1;
  static Database? _db;

  static Future<Database> instance() async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'vmcast.db');
    _db = await openDatabase(path, version: _kVersion, onCreate: _onCreate);
    return _db!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recordings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        file_path TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        duration_ms INTEGER
      );
    ''');
    await db.execute('''
      CREATE TABLE transcripts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recording_id INTEGER NOT NULL,
        lang TEXT,
        text TEXT,
        FOREIGN KEY(recording_id) REFERENCES recordings(id) ON DELETE CASCADE
      );
    ''');
    await db.execute('CREATE INDEX idx_recordings_created ON recordings(created_at DESC);');
    await db.execute('CREATE INDEX idx_transcripts_text ON transcripts(recording_id);');
  }
}


