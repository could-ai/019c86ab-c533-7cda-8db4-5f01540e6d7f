import 'package:flutter/material.dart';
import 'screens/directory_screen.dart';

void main() {
  runApp(const InurlDirectoryApp());
}

class InurlDirectoryApp extends StatelessWidget {
  const InurlDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inurl Keyword Directory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8), // Google Blue-ish
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        cardTheme: const CardTheme(
          elevation: 0,
          color: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DirectoryScreen(),
      },
    );
  }
}
