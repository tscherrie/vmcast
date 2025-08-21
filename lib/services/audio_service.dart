import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> initialize() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  }

  Future<void> setSource(String filePath) async {
    await _player.setFilePath(filePath);
  }

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  Stream<Duration?> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Future<void> dispose() async {
    await _player.dispose();
  }
}


