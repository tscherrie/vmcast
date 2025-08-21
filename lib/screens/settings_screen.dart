import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = 'settings';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Playback speed (global)'),
            subtitle: Text('0.5x–3.0x'),
          ),
          ListTile(
            title: Text('Bootstrap relays'),
            subtitle: Text('Configured via .env or in-app settings (planned)'),
          ),
          ListTile(
            title: Text('On-device AI models'),
            subtitle: Text('Download/manage in M3'),
          ),
        ],
      ),
    );
  }
}


