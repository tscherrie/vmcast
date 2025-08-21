import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VmListScreen extends StatelessWidget {
  static const String routeName = 'vm-list';
  final String contactId;
  const VmListScreen({super.key, required this.contactId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VMs — $contactId')),
      body: ListView.separated(
        itemCount: 3,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final vmId = 'vm$index';
          return ListTile(
            leading: const Icon(Icons.play_circle_filled),
            title: Text('Voice message #$index'),
            subtitle: const Text('00:42 • delivered'),
            onTap: () => context.go('/contact/$contactId/vm/$vmId'),
          );
        },
      ),
    );
  }
}


