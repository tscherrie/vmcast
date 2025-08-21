import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = 'settings';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Consumer<AppState>(
        builder: (context, app, _) {
          return ListView(
            children: [
              ListTile(
                title: const Text('Playback speed (global)'),
                subtitle: Text('${app.playbackSpeed}x'),
                trailing: DropdownButton<double>(
                  value: app.playbackSpeed,
                  items: const [
                    0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0
                  ]
                      .map((v) => DropdownMenuItem(value: v, child: Text('${v}x')))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) app.setPlaybackSpeed(v);
                  },
                ),
              ),
              const ListTile(
                title: Text('Bootstrap relays'),
                subtitle: Text('Configured via .env or in-app settings (planned)'),
              ),
              const ListTile(
                title: Text('On-device AI models'),
                subtitle: Text('Download/manage in M3'),
              ),
            ],
          );
        },
      ),
    );
  }
}


