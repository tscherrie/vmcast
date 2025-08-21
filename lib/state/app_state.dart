import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static const String _kPlaybackSpeedKey = 'playback_speed';

  double _playbackSpeed = 1.0;
  double get playbackSpeed => _playbackSpeed;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _playbackSpeed = prefs.getDouble(_kPlaybackSpeedKey) ?? 1.0;
    notifyListeners();
  }

  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kPlaybackSpeedKey, speed);
  }
}


