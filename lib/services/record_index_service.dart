import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class RecordingEntry {
  final String filePath;
  final DateTime createdAt;
  const RecordingEntry({required this.filePath, required this.createdAt});
}

class RecordIndexService {
  Future<Directory> _recordingsDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory(p.join(dir.path, 'recordings'));
    await recordingsDir.create(recursive: true);
    return recordingsDir;
  }

  Future<List<RecordingEntry>> listRecordings() async {
    final dir = await _recordingsDir();
    final entries = <RecordingEntry>[];
    await for (final entity in dir.list()) {
      if (entity is File && (entity.path.endsWith('.m4a') || entity.path.endsWith('.aac'))) {
        final stat = await entity.stat();
        entries.add(RecordingEntry(filePath: entity.path, createdAt: stat.changed));
      }
    }
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  Future<bool> deleteRecording(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      return true;
    }
    return false;
  }
}


