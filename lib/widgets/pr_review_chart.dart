// lib/widgets/pr_review_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/metrics_models.dart';

class PRReviewChart extends StatelessWidget {
  final PRReviewTimes data;

  const PRReviewChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Summary Stats
        Row(
          children: [
            _PRStatCard(
              title: 'Merged PRs',
              value: '${data.summary.totalMerged}',
              subtitle: 'Last 90 days',
              icon: Icons.check_circle,
              color: Colors.green,
            ),
            const SizedBox(width: 16),
            _PRStatCard(
              title: 'Open PRs',
              value: '${data.summary.totalOpen}',
              subtitle: 'Awaiting review',
              icon: Icons.pending,
              color: Colors.orange,
            ),
            const SizedBox(width: 16),
            _PRStatCard(
              title: 'Avg Time to Merge',
              value: _formatHours(data.summary.averageHoursToMerge),
              subtitle: 'Average',
              icon: Icons.timer,
              color: Colors.blue,
            ),
            const SizedBox(width: 16),
            _PRStatCard(
              title: 'Median Time',
              value: _formatHours(data.summary.medianHoursToMerge),
              subtitle: 'Median',
              icon: Icons.analytics,
              color: Colors.purple,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Distribution Pie Chart & By Repo
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Distribution
            Expanded(
              child: Container(
                height: 350,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⏱️ Time to Merge Distribution',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: data.distribution.under1Hour.toDouble(),
                                    title: '<1h',
                                    color: Colors.green,
                                    radius: 80,
                                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  PieChartSectionData(
                                    value: (data.distribution.under4Hours - data.distribution.under1Hour).toDouble(),
                                    title: '1-4h',
                                    color: Colors.lightGreen,
                                    radius: 80,
                                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  PieChartSectionData(
                                    value: (data.distribution.under24Hours - data.distribution.under4Hours).toDouble(),
                                    title: '4-24h',
                                    color: Colors.amber,
                                    radius: 80,
                                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  PieChartSectionData(
                                    value: (data.distribution.under72Hours - data.distribution.under24Hours).toDouble(),
                                    title: '1-3d',
                                    color: Colors.orange,
                                    radius: 80,
                                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  PieChartSectionData(
                                    value: data.distribution.over72Hours.toDouble(),
                                    title: '>3d',
                                    color: Colors.red,
                                    radius: 80,
                                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _LegendItem(color: Colors.green, label: '< 1 hour', count: data.distribution.under1Hour),
                              _LegendItem(color: Colors.lightGreen, label: '1-4 hours', count: data.distribution.under4Hours - data.distribution.under1Hour),
                              _LegendItem(color: Colors.amber, label: '4-24 hours', count: data.distribution.under24Hours - data.distribution.under4Hours),
                              _LegendItem(color: Colors.orange, label: '1-3 days', count: data.distribution.under72Hours - data.distribution.under24Hours),
                              _LegendItem(color: Colors.red, label: '> 3 days', count: data.distribution.over72Hours),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),

            // By Repo
            Expanded(
              child: Container(
                height: 350,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📁 Review Time by Repository',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.byRepo.take(8).length,
                        itemBuilder: (context, index) {
                          final repo = data.byRepo[index];
                          final avgHours = repo.average;
                          Color barColor;
                          if (avgHours < 4) {
                            barColor = Colors.green;
                          } else if (avgHours < 24) {
                            barColor = Colors.amber;
                          } else if (avgHours < 72) {
                            barColor = Colors.orange;
                          } else {
                            barColor = Colors.red;
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        repo.repo,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    Text(
                                      _formatHours(avgHours),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: barColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: (avgHours / 100).clamp(0, 1),
                                  backgroundColor: Colors.grey[800],
                                  valueColor: AlwaysStoppedAnimation(barColor),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // By Author Table
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '👤 PR Review Time by Author',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  const TableRow(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Author', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('PRs Merged', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Avg Time', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  ...data.byAuthor.take(10).map((author) {
                    final avgHours = author.averageHours;
                    Color timeColor;
                    if (avgHours < 4) {
                      timeColor = Colors.green;
                    } else if (avgHours < 24) {
                      timeColor = Colors.amber;
                    } else {
                      timeColor = Colors.red;
                    }

                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage(
                                  'https://github.com/${author.author}.png',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(author.author),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text('${author.prCount}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            _formatHours(avgHours),
                            style: TextStyle(color: timeColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatHours(double hours) {
    if (hours < 1) {
      return '${(hours * 60).round()}m';
    } else if (hours < 24) {
      return '${hours.toStringAsFixed(1)}h';
    } else {
      return '${(hours / 24).toStringAsFixed(1)}d';
    }
  }
}

class _PRStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _PRStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text('$label ($count)'),
        ],
      ),
    );
  }
}