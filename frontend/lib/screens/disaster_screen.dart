// lib/screens/disaster_screen.dart
import 'package:flutter/material.dart';

class DisasterScreen extends StatelessWidget {
  const DisasterScreen({super.key});

  static const List<_Disaster> disasters = [
    _Disaster(name: "Flood", icon: Icons.water_damage),
    _Disaster(name: "Earthquake", icon: Icons.landscape),
    _Disaster(name: "Cyclone", icon: Icons.air),
    _Disaster(name: "Tsunami", icon: Icons.waves),
    _Disaster(name: "Drought", icon: Icons.grass),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Disaster Guides")),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: disasters.length,
        itemBuilder: (context, index) {
          final d = disasters[index];
          return ListTile(
            leading: CircleAvatar(child: Icon(d.icon)),
            title: Text(d.name),
            subtitle: const Text("Before • During • After"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DisasterDetailScreen(disaster: d),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _Disaster {
  final String name;
  final IconData icon;
  const _Disaster({required this.name, required this.icon});
}

class DisasterDetailScreen extends StatelessWidget {
  final _Disaster disaster;
  const DisasterDetailScreen({super.key, required this.disaster});

  Widget _section(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(body),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder content. Eventually these will come from RAG/backend.
    final before =
        "${disaster.name} - BEFORE: Prepare kit, plan evacuation route, secure property.";
    final during =
        "${disaster.name} - DURING: Stay safe, follow official instructions, avoid risky areas.";
    final after =
        "${disaster.name} - AFTER: Check for injuries, report damage, avoid hazards.";

    return Scaffold(
      appBar: AppBar(title: Text(disaster.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(disaster.icon, size: 36),
                const SizedBox(width: 12),
                Text(
                  disaster.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 18),
            _section("BEFORE", before),
            _section("DURING", during),
            _section("AFTER", after),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                // Suggest: integrate with chat assistant for more detailed answers
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Open AI Assistant for tailored guidance."),
                  ),
                );
              },
              icon: const Icon(Icons.chat),
              label:  Text(
                "Ask the Assistant about ${disaster.name}",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
