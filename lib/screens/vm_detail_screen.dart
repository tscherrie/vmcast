import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class VmDetailScreen extends StatefulWidget {
  static const String routeName = 'vm-detail';
  final String contactId;
  final String vmId;

  const VmDetailScreen({super.key, required this.contactId, required this.vmId});

  @override
  State<VmDetailScreen> createState() => _VmDetailScreenState();
}

class _VmDetailScreenState extends State<VmDetailScreen> {
  final AudioService _audio = AudioService();
  bool _ready = false;
  double _speed = 1.0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _audio.initialize();
    final path = Uri.decodeComponent(widget.vmId);
    await _audio.setSource(path);
    if (mounted) {
      setState(() => _ready = true);
    }
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VM ${widget.vmId.split('/').last}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_ready) const Center(child: CircularProgressIndicator()),
            if (_ready)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_10),
                    onPressed: () => _audio.seek(const Duration(seconds: 0)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: _audio.play,
                  ),
                  IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: _audio.pause,
                  ),
                  const SizedBox(width: 12),
                  Consumer<AppState>(
                    builder: (context, app, _) {
                      _speed = app.playbackSpeed;
                      return DropdownButton<double>(
                        value: _speed,
                        items: const [
                          0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0
                        ]
                            .map((v) => DropdownMenuItem(value: v, child: Text('${v}x')))
                            .toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          app.setPlaybackSpeed(v);
                          _audio.setSpeed(v);
                        },
                      );
                    },
                  ),
                ],
              ),
            const SizedBox(height: 16),
            const Text('Transcript placeholder'),
          ],
        ),
      ),
    );
  }
}


