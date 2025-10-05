import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'healthkit_api.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Future<HealthSummary> _loadSummary() {
    final api = HealthKitApi();
    return api.getHealthSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Health Summary',
          style: ShadTheme.of(context).textTheme.h2,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<HealthSummary>(
            future: _loadSummary(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Failed to load health data',
                    style: ShadTheme.of(context).textTheme.muted,
                  ),
                );
              }
              final data = snapshot.data;
              if (data == null) {
                return Center(
                  child: Text(
                    'No data available',
                    style: ShadTheme.of(context).textTheme.muted,
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.25,
                      children: [
                        _MetricCard(
                          title: 'Steps',
                          value: data.steps.toString(),
                          subtitle: 'Today',
                        ),
                        _MetricCard(
                          title: 'Calories',
                          value: data.calories.toStringAsFixed(0),
                          subtitle: 'kcal',
                        ),
                        _MetricCard(
                          title: 'Avg Heart Rate',
                          value: data.avgHeartRate.toStringAsFixed(0),
                          subtitle: 'bpm',
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: ShadTheme.of(context).textTheme.muted),
          const SizedBox(height: 8),
          Text(value, style: ShadTheme.of(context).textTheme.h1),
          const SizedBox(height: 8),
          Text(subtitle, style: ShadTheme.of(context).textTheme.small),
        ],
      ),
    );
  }
}
