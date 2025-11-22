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
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Text(
              "GeoSafe",
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text("Open AI Assistant"),
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const ChatScreen()));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.warning_amber_outlined),
              label: const Text("Disaster Guides"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DisasterScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.kitchen_outlined),
              label: const Text("Emergency Kit Info"),
              onPressed: () {
                // For now, show simple dialog (placeholder)
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Emergency Kit"),
                    content: const Text(
                      "Basic items:\n- Water (3L per person/day)\n- First-aid kit\n- Flashlight + batteries\n- Copies of important documents\n\n(We'll add detailed guidance soon.)",
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
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.info_outline),
              label: const Text("About GeoSafe"),
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationName: "GeoSafe",
                  applicationVersion: "0.1.0",
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
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const Spacer(),
            Text(
              "Built for offline/local LLM integration",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
