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

          // -------------------- COLOR SCHEME --------------------
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF0D3B66),
            onPrimary: Colors.white,
            secondary: Color(0xFFFAF0CA),
            onSecondary: Color(0xFF0D3B66),
            tertiary: Color(0xFFE0C097),
            onTertiary: Color(0xFF0D3B66),
            error: Color(0xFFBA1A1A),
            onError: Colors.white,
            background: Color(0xFFFAF0CA),
            onBackground: Color(0xFF0D3B66),
            surface: Color(0xFFFAF0CA),
            onSurface: Color(0xFF0D3B66),
            surfaceVariant: Color(0xFFEBE2CF),
            onSurfaceVariant: Color(0xFF44474F),
            outline: Color(0xFF74777F),
            shadow: Colors.black,
            scrim: Colors.black,
            inverseSurface: Color(0xFF0D3B66),
            inversePrimary: Color(0xFFFAF0CA),
          ),

          scaffoldBackgroundColor: const Color(0xFFFAF0CA),

          // -------------------- APPBAR --------------------------
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFFAF0CA),
            foregroundColor: Color(0xFF0D3B66),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Color(0xFF0D3B66),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          // ------------------ ELEVATED BUTTON -------------------
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D3B66),
              foregroundColor: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),

          // ------------------ OUTLINED BUTTON -------------------
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0D3B66),
              side: const BorderSide(color: Color(0xFF0D3B66), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),

          // ---------------------- CARD THEME ---------------------
          cardTheme: const CardThemeData(
            color: Colors.white,
            elevation: 2,
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),

          // ---------------- INPUT DECORATION THEME --------------
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Color(0xFF0D3B66), width: 2),
            ),
            hintStyle: TextStyle(
              color: const Color(0xFF0D3B66).withOpacity(0.5),
            ),
          ),

          // ---------------------- TEXT THEME ---------------------
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF0D3B66)),
            bodyMedium: TextStyle(color: Color(0xFF0D3B66)),
            bodySmall: TextStyle(color: Color(0xFF0D3B66)),
            titleLarge: TextStyle(
                color: Color(0xFF0D3B66), fontWeight: FontWeight.bold),
            titleMedium: TextStyle(color: Color(0xFF0D3B66)),
          ),

          iconTheme: const IconThemeData(color: Color(0xFF0D3B66)),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
