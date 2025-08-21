import 'package:flutter/material.dart';
import '../services/recording_service.dart';
import '../services/record_index_service.dart';

class RecordScreen extends StatefulWidget {
  static const String routeName = 'record';
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final RecordingService _recording = RecordingService();
  final RecordIndexService _index = RecordIndexService();
  String? _currentPath;
  bool _isRecording = false;
  String _status = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mic, size: 64),
            const SizedBox(height: 16),
            if (!_isRecording)
              ElevatedButton(
                onPressed: () async {
                  final path = await _recording.start();
                  setState(() {
                    if (path != null) {
                      _currentPath = path;
                      _isRecording = true;
                      _status = 'Recording…';
                    } else {
                      _status = 'Failed to start (permission or encoder)';
                    }
                  });
                },
                child: const Text('Start recording'),
              )
            else
              ElevatedButton(
                onPressed: () async {
                  final path = await _recording.stop();
                  setState(() {
                    _currentPath = path ?? _currentPath;
                    _isRecording = false;
                    _status = 'Saved';
                  });
                  // Warm refresh by touching index once
                  await _index.listRecordings();
                },
                child: const Text('Stop'),
              ),
            const SizedBox(height: 12),
            Text(
              _currentPath == null ? _status : (_isRecording ? 'Recording…' : 'Saved: $_currentPath'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            FutureBuilder<bool>(
              future: _recording.isRecording(),
              builder: (context, snapshot) {
                final rec = snapshot.data == true;
                return Text('isRecording: $rec', style: const TextStyle(fontSize: 12, color: Colors.grey));
              },
            ),
          ],
        ),
      ),
    );
  }
}


