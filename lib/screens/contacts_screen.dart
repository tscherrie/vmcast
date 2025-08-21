import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/mini_player.dart';

class ContactsScreen extends StatelessWidget {
  static const String routeName = 'contacts';
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('vmcast'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.go('/search'),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('Demo Contact'),
            subtitle: const Text('@demo'),
            onTap: () => context.go('/contact/demo'),
          ),
        ],
      ),
      bottomNavigationBar: const MiniPlayer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/record'),
        label: const Text('Record'),
        icon: const Icon(Icons.mic),
      ),
    );
  }
}


