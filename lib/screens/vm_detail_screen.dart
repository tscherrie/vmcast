import 'package:flutter/material.dart';

class VmDetailScreen extends StatelessWidget {
  static const String routeName = 'vm-detail';
  final String contactId;
  final String vmId;

  const VmDetailScreen({super.key, required this.contactId, required this.vmId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VM $vmId')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Text('Player placeholder'),
            SizedBox(height: 16),
            Text('Transcript placeholder'),
          ],
        ),
      ),
    );
  }
}


