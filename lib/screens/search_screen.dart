import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import '../repository/recordings_repository.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = 'search';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final RecordingsRepository _repo = RecordingsRepository();
  String _query = '';
  List<RecordingRow> _results = const [];
  bool _loading = false;

  Future<void> _run() async {
    setState(() => _loading = true);
    final rows = await _repo.search(_query);
    setState(() {
      _results = rows;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Search recordings'),
          onChanged: (v) => _query = v,
          onSubmitted: (_) => _run(),
        ),
        actions: [
          IconButton(onPressed: _run, icon: const Icon(Icons.search)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _results.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final r = _results[index];
                final vmId = Uri.encodeComponent(r.filePath);
                return ListTile(
                  leading: const Icon(Icons.audiotrack),
                  title: Text(p.basename(r.filePath)),
                  subtitle: Text(r.createdAt.toLocal().toString()),
                  onTap: () => context.go('/contact/demo/vm/$vmId'),
                );
              },
            ),
    );
  }
}


