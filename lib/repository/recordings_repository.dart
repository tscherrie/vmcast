import 'package:sqflite/sqflite.dart';
import '../db/app_database.dart';

class RecordingRow {
  final int id;
  final String filePath;
  final DateTime createdAt;
  final int? durationMs;
  RecordingRow({required this.id, required this.filePath, required this.createdAt, this.durationMs});
}

class RecordingsRepository {
  static const String _table = 'recordings';

  Future<int> upsertByPath({required String filePath, required DateTime createdAt, int? durationMs}) async {
    final db = await AppDatabase.instance();
    // Try update by path; if 0 rows, insert.
    final count = await db.update(
      _table,
      {
        'created_at': createdAt.millisecondsSinceEpoch,
        'duration_ms': durationMs,
      },
      where: 'file_path = ?',
      whereArgs: [filePath],
    );
    if (count == 0) {
      return db.insert(
        _table,
        {
          'file_path': filePath,
          'created_at': createdAt.millisecondsSinceEpoch,
          'duration_ms': durationMs,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return count;
  }

  Future<List<RecordingRow>> recent({int limit = 100}) async {
    final db = await AppDatabase.instance();
    final rows = await db.query(_table, orderBy: 'created_at DESC', limit: limit);
    return rows
        .map((r) => RecordingRow(
              id: r['id'] as int,
              filePath: r['file_path'] as String,
              createdAt: DateTime.fromMillisecondsSinceEpoch(r['created_at'] as int),
              durationMs: r['duration_ms'] as int?,
            ))
        .toList();
  }

  Future<void> deleteByPath(String filePath) async {
    final db = await AppDatabase.instance();
    await db.delete(_table, where: 'file_path = ?', whereArgs: [filePath]);
  }

  Future<List<RecordingRow>> search(String q) async {
    final db = await AppDatabase.instance();
    final like = '%$q%';
    final rows = await db.query(
      _table,
      where: 'file_path LIKE ? COLLATE NOCASE',
      whereArgs: [like],
      orderBy: 'created_at DESC',
      limit: 200,
    );
    return rows
        .map((r) => RecordingRow(
              id: r['id'] as int,
              filePath: r['file_path'] as String,
              createdAt: DateTime.fromMillisecondsSinceEpoch(r['created_at'] as int),
              durationMs: r['duration_ms'] as int?,
            ))
        .toList();
  }
}


