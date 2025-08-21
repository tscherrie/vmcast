import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_controller.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioController>(
      builder: (context, audio, _) {
        if (audio.currentPath == null) return const SizedBox.shrink();
        final duration = audio.duration ?? Duration.zero;
        final position = audio.position;
        final progress = duration.inMilliseconds == 0
            ? 0.0
            : position.inMilliseconds / duration.inMilliseconds;
        return Material(
          elevation: 3,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(audio.isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () => audio.isPlaying ? audio.pause() : audio.play(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          audio.currentPath!.split('/').last,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        LinearProgressIndicator(value: progress.clamp(0.0, 1.0)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(_format(position)),
                  const Text(' / '),
                  Text(_format(duration)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return h > 0 ? '${two(h)}:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }
}


