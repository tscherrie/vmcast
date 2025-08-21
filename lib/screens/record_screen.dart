import 'package:flutter/material.dart';
import '../services/recording_service.dart';

class RecordScreen extends StatefulWidget {
  static const String routeName = 'record';
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final RecordingService _recording = RecordingService();
  String? _currentPath;
  bool _isRecording = false;

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
                  if (path != null) {
                    setState(() {
                      _currentPath = path;
                      _isRecording = true;
                    });
                  }
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
                  });
                },
                child: const Text('Stop'),
              ),
            const SizedBox(height: 12),
            if (_currentPath != null)
              Text(
                _isRecording ? 'Recording…' : 'Saved: $_currentPath',
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}


