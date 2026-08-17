import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/chat_screen.dart';
import 'viewmodels/chat_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://ckchoyjpyppfwvneylkv.supabase.co',
    ),
    anonKey: const String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: 'sb_publishable_462buVgwumaavPfAydnACg_qhqJhkRP',
    ),
  );

  // Connexion anonyme : chaque appareil a son propre espace de données.
  if (Supabase.instance.client.auth.currentSession == null) {
    await Supabase.instance.client.auth.signInAnonymously();
  }

  runApp(const KimiApp());
}

class KimiApp extends StatelessWidget {
  const KimiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(),
      child: MaterialApp(
        title: 'Kimi',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
