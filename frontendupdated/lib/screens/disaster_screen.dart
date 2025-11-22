// lib/screens/disaster_screen.dart
import 'package:flutter/material.dart';

class DisasterScreen extends StatelessWidget {
  const DisasterScreen({super.key});

  static const List<_Disaster> disasters = [
    _Disaster(name: "Flood", icon: Icons.water_drop_outlined),
    _Disaster(name: "Earthquake", icon: Icons.landscape_outlined),
    _Disaster(name: "Cyclone", icon: Icons.cyclone_outlined),
    _Disaster(name: "Tsunami", icon: Icons.tsunami_outlined),
    _Disaster(name: "Drought", icon: Icons.wb_sunny_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Disaster Guides")),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: disasters.length,
        itemBuilder: (context, index) {
          final d = disasters[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.05),
                width: 1,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DisasterDetailScreen(disaster: d),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        d.icon,
                        color: theme.colorScheme.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Before • During • After",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: theme.colorScheme.primary.withOpacity(0.4),
                    ),
                  ],
                ),
              ),
            ),
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

  Widget _section(BuildContext context, String title, String body) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Placeholder content. Eventually these will come from RAG/backend.
    final before =
        "Prepare kit, plan evacuation route, secure property. Ensure you have enough water and non-perishable food for at least 3 days.";
    final during =
        "Stay safe, follow official instructions, avoid risky areas. If you are indoors, stay away from windows. If outdoors, move to higher ground.";
    final after =
        "Check for injuries, report damage, avoid hazards. Do not drink tap water until authorities say it is safe.";

    return Scaffold(
      appBar: AppBar(title: Text(disaster.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  disaster.icon,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                "${disaster.name} Safety Guide",
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            _section(context, "BEFORE", before),
            _section(context, "DURING", during),
            _section(context, "AFTER", after),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Suggest: integrate with chat assistant for more detailed answers
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Open AI Assistant for tailored guidance."),
                      backgroundColor: theme.colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: Text("Ask Assistant about ${disaster.name}"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
