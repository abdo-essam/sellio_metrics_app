// lib/widgets/summary_cards.dart

import 'package:flutter/material.dart';
import '../models/metrics_models.dart';

class SummaryCards extends StatelessWidget {
  final MetricsSummary summary;

  const SummaryCards({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _MetricCard(
          icon: Icons.folder_outlined,
          title: 'Repositories',
          value: '${summary.totalRepos}',
          color: Colors.blue,
        ),
        _MetricCard(
          icon: Icons.commit,
          title: 'Commits (30d)',
          value: '${summary.totalCommitsLast30Days}',
          color: Colors.green,
        ),
        _MetricCard(
          icon: Icons.call_merge,
          title: 'Open PRs',
          value: '${summary.totalOpenPRs}',
          color: Colors.purple,
        ),
        _MetricCard(
          icon: Icons.bug_report_outlined,
          title: 'Open Issues',
          value: '${summary.totalOpenIssues}',
          color: Colors.orange,
        ),
        _MetricCard(
          icon: Icons.check_circle_outline,
          title: 'Closed Issues',
          value: '${summary.totalClosedIssues}',
          color: Colors.teal,
        ),
        _MetricCard(
          icon: Icons.speed,
          title: 'Resolution Rate',
          value: '${summary.issueResolutionRate}%',
          color: Colors.pink,
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}