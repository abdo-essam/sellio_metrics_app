import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/metrics_provider.dart';
import '../widgets/summary_cards.dart';
import '../widgets/commit_velocity_chart.dart';
import '../widgets/pr_review_chart.dart';
import '../widgets/issue_resolution_chart.dart';
import '../widgets/contributors_grid.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MetricsProvider>().loadAllMetrics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Row(
          children: [
            Image.network(
              'https://github.com/Sellio-Squad.png',
              width: 32,
              height: 32,
              errorBuilder: (_, __, ___) => const Icon(Icons.business),
            ),
            const SizedBox(width: 12),
            const Text('Sellio Squad Metrics'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MetricsProvider>().loadAllMetrics();
            },
          ),
        ],
      ),
      body: Consumer<MetricsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading metrics from GitHub...'),
                ],
              ),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${provider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadAllMetrics(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadAllMetrics(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards
                  if (provider.summary != null) ...[
                    const Text(
                      '📊 Overview',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SummaryCards(summary: provider.summary!),
                    const SizedBox(height: 32),
                  ],

                  // Commit Velocity
                  if (provider.commitVelocity != null) ...[
                    const Text(
                      '📈 Commit Velocity',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    CommitVelocityChart(data: provider.commitVelocity!),
                    const SizedBox(height: 32),
                  ],

                  // PR Review Times
                  if (provider.prReviewTimes != null) ...[
                    const Text(
                      '🔀 PR Review Times',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    PRReviewChart(data: provider.prReviewTimes!),
                    const SizedBox(height: 32),
                  ],

                  // Issue Resolution
                  if (provider.issueResolution != null) ...[
                    const Text(
                      '🐛 Issue Resolution',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    IssueResolutionChart(data: provider.issueResolution!),
                    const SizedBox(height: 32),
                  ],

                  // Contributors
                  if (provider.contributorStats != null) ...[
                    const Text(
                      '👥 Team Contributors',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ContributorsGrid(data: provider.contributorStats!),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}