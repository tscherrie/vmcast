import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'screens/contacts_screen.dart';
import 'screens/vm_list_screen.dart';
import 'screens/vm_detail_screen.dart';
import 'screens/record_screen.dart';
import 'screens/settings_screen.dart';
import 'state/app_state.dart';

class VmcastApp extends StatefulWidget {
  const VmcastApp({super.key});

  @override
  State<VmcastApp> createState() => _VmcastAppState();
}

class _VmcastAppState extends State<VmcastApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: ContactsScreen.routeName,
          builder: (context, state) => const ContactsScreen(),
          routes: [
            GoRoute(
              path: 'contact/:contactId',
              name: VmListScreen.routeName,
              builder: (context, state) => VmListScreen(
                contactId: state.pathParameters['contactId']!,
              ),
              routes: [
                GoRoute(
                  path: 'vm/:vmId',
                  name: VmDetailScreen.routeName,
                  builder: (context, state) => VmDetailScreen(
                    contactId: state.pathParameters['contactId']!,
                    vmId: state.pathParameters['vmId']!,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: 'record',
              name: RecordScreen.routeName,
              builder: (context, state) => const RecordScreen(),
            ),
            GoRoute(
              path: 'settings',
              name: SettingsScreen.routeName,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..load(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'vmcast',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}


