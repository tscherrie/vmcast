import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../services/audio_controller.dart';
import '../widgets/mini_player.dart';

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
  Duration _position = Duration.zero;
  Duration? _duration;

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
    _audio.positionStream.listen((d) {
      if (!mounted) return;
      setState(() => _position = d ?? Duration.zero);
    });
    _audio.durationStream.listen((d) {
      if (!mounted) return;
      setState(() => _duration = d);
    });
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AudioController>();
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
                    onPressed: () {
                      final newPos = _position - const Duration(seconds: 10);
                      _audio.seek(newPos < Duration.zero ? Duration.zero : newPos);
                    },
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
                  IconButton(
                    icon: const Icon(Icons.forward_10),
                    onPressed: () {
                      final dur = _duration ?? Duration.zero;
                      final newPos = _position + const Duration(seconds: 10);
                      _audio.seek(newPos > dur ? dur : newPos);
                    },
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final path = Uri.decodeComponent(widget.vmId);
                      await controller.setSource(path);
                      await controller.play();
                    },
                    child: const Text('Play in mini'),
                  ),
                ],
              ),
            if (_duration != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Slider(
                    value: _position.inMilliseconds.clamp(0, _duration!.inMilliseconds).toDouble(),
                    max: _duration!.inMilliseconds.toDouble(),
                    onChanged: (v) => _audio.seek(Duration(milliseconds: v.toInt())),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_fmt(_position)),
                      Text(_fmt(_duration!)),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 16),
            const Text('Transcript placeholder'),
          ],
        ),
      ),
      bottomNavigationBar: const MiniPlayer(),
    );
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return h > 0 ? '${two(h)}:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }
}


