import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class RecordingService {
  final AudioRecorder _recorder = AudioRecorder();

  Future<bool> ensurePermissions() async {
    final mic = await Permission.microphone.request();
    return mic.isGranted;
  }

  Future<String> _nextFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory('${dir.path}/recordings');
    await recordingsDir.create(recursive: true);
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '${recordingsDir.path}/vm_$ts.m4a';
  }

  Future<String?> start() async {
    if (!await ensurePermissions()) return null;
    final path = await _nextFilePath();
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 24000,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: path,
    );
    return path;
  }

  Future<String?> stop() => _recorder.stop();

  Future<bool> isRecording() => _recorder.isRecording();

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}


