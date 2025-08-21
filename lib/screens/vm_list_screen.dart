import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/record_index_service.dart';
import 'package:path/path.dart' as p;

class VmListScreen extends StatefulWidget {
  static const String routeName = 'vm-list';
  final String contactId;
  const VmListScreen({super.key, required this.contactId});

  @override
  State<VmListScreen> createState() => _VmListScreenState();
}

class _VmListScreenState extends State<VmListScreen> {
  final RecordIndexService _index = RecordIndexService();
  late Future<List<RecordingEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = _index.listRecordings();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _index.listRecordings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VMs — ${widget.contactId}')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<RecordingEntry>>(
          future: _future,
          builder: (context, snapshot) {
            final items = snapshot.data ?? const <RecordingEntry>[];
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (items.isEmpty) {
              return const Center(child: Text('No local recordings yet'));
            }
            return ListView.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final entry = items[index];
                final vmId = Uri.encodeComponent(entry.filePath);
                return ListTile(
                  leading: const Icon(Icons.play_circle_filled),
                  title: Text(p.basename(entry.filePath)),
                  subtitle: Text(entry.createdAt.toLocal().toString()),
                  onTap: () => context.go('/contact/${widget.contactId}/vm/$vmId'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}


