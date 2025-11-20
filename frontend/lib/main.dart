// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';
import 'providers/chat_provider.dart';

void main() {
  runApp(const GeoSafeApp());
}

class GeoSafeApp extends StatelessWidget {
  const GeoSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider<ChatProvider>(
          create: (ctx) => ChatProvider(api: ctx.read<ApiService>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GeoSafe',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          brightness: Brightness.light,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
