import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioController extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  String? _currentPath;

  String? get currentPath => _currentPath;
  Stream<Duration?> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  PlayerState get playerState => _player.playerState;

  Future<void> initialize() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  }

  Future<void> setSource(String filePath) async {
    _currentPath = filePath;
    await _player.setFilePath(filePath);
    notifyListeners();
  }

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  Duration? get duration => _player.duration;
  Duration get position => _player.position;

  bool get isPlaying => _player.playing;

  Future<void> disposeController() async {
    await _player.dispose();
  }
}


