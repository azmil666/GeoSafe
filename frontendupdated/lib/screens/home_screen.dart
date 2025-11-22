// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'disaster_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoSafe'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Text(
              "GeoSafe",
              style: theme.textTheme.displaySmall,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8),
            Text(
              "Your offline disaster companion.",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text("Open AI Assistant"),
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const ChatScreen()));
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.warning_amber_rounded),
              label: const Text("Disaster Guides"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DisasterScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.medical_services_outlined),
              label: const Text("Emergency Kit Info"),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: theme.colorScheme.surface,
                    title: Text("Emergency Kit", style: theme.textTheme.titleLarge),
                    content: Text(
                      "Basic items:\n• Water (3L per person/day)\n• First-aid kit\n• Flashlight + batteries\n• Copies of important documents",
                      style: theme.textTheme.bodyMedium,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.info_outline),
              label: const Text("About GeoSafe"),
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationName: "GeoSafe",
                  applicationVersion: "0.1.0",
                  applicationIcon: Icon(Icons.shield, color: theme.colorScheme.primary, size: 48),
                  children: const [
                    Text(
                      "Frontend demo that connects to a local LLM backend for disaster guidance.",
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Backend: FastAPI + llama.cpp + Granite 3.0 (2B) Q4_K_M + ChromaDB (multi-collection RAG)",
                    ),
                  ],
                );
              },
            ),
            const Spacer(),
            Text(
              "Built for offline/local LLM integration",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
