// lib/widgets/contributors_grid.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/metrics_models.dart';

class ContributorsGrid extends StatelessWidget {
  final ContributorStats data;

  const ContributorsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Summary Stats
        Row(
          children: [
            _ContribStatCard(
              title: 'Contributors',
              value: '${data.summary.totalContributors}',
              icon: Icons.people,
              color: Colors.blue,
            ),
            const SizedBox(width: 16),
            _ContribStatCard(
              title: 'Total Commits',
              value: '${data.summary.totalCommits}',
              icon: Icons.commit,
              color: Colors.green,
            ),
            const SizedBox(width: 16),
            _ContribStatCard(
              title: 'Total PRs',
              value: '${data.summary.totalPRs}',
              icon: Icons.call_merge,
              color: Colors.purple,
            ),
            const SizedBox(width: 16),
            _ContribStatCard(
              title: 'Code Reviews',
              value: '${data.summary.totalReviews}',
              icon: Icons.rate_review,
              color: Colors.orange,
            ),
            const SizedBox(width: 16),
            _ContribStatCard(
              title: 'Issues Closed',
              value: '${data.summary.totalIssuesClosed}',
              icon: Icons.bug_report,
              color: Colors.teal,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Leaderboards Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top by Activity Score
            Expanded(
              child: _LeaderboardCard(
                title: '🏆 Top Contributors (Activity Score)',
                contributors: data.topByActivity,
                metricBuilder: (c) => '${c.activityScore} pts',
                metricColor: const Color(0xFFFFD700),
              ),
            ),
            const SizedBox(width: 16),

            // Top Committers
            Expanded(
              child: _LeaderboardCard(
                title: '💻 Top Committers',
                contributors: data.topCommitters,
                metricBuilder: (c) => '${c.commits} commits',
                metricColor: Colors.green,
              ),
            ),
            const SizedBox(width: 16),

            // Top Reviewers
            Expanded(
              child: _LeaderboardCard(
                title: '👀 Top Reviewers',
                contributors: data.topReviewers,
                metricBuilder: (c) => '${c.prsReviewed} reviews',
                metricColor: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Full Contributor Table
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
                '📊 All Contributors (Last 30 Days)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Contributor')),
                    DataColumn(label: Text('Commits'), numeric: true),
                    DataColumn(label: Text('PRs Opened'), numeric: true),
                    DataColumn(label: Text('PRs Merged'), numeric: true),
                    DataColumn(label: Text('Reviews'), numeric: true),
                    DataColumn(label: Text('Issues Closed'), numeric: true),
                    DataColumn(label: Text('Lines Changed'), numeric: true),
                    DataColumn(label: Text('Repos'), numeric: true),
                    DataColumn(label: Text('Score'), numeric: true),
                  ],
                  rows: data.contributors.map((contributor) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(contributor.avatarUrl),
                                onBackgroundImageError: (_, __) {},
                              ),
                              const SizedBox(width: 12),
                              Text(
                                contributor.username,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        DataCell(_MetricBadge(
                          value: contributor.commits,
                          color: Colors.green,
                        )),
                        DataCell(_MetricBadge(
                          value: contributor.prsOpened,
                          color: Colors.blue,
                        )),
                        DataCell(_MetricBadge(
                          value: contributor.prsMerged,
                          color: Colors.purple,
                        )),
                        DataCell(_MetricBadge(
                          value: contributor.prsReviewed,
                          color: Colors.orange,
                        )),
                        DataCell(_MetricBadge(
                          value: contributor.issuesClosed,
                          color: Colors.teal,
                        )),
                        DataCell(Text(
                          _formatNumber(contributor.linesChanged),
                          style: TextStyle(
                            color: contributor.linesChanged > 1000 ? Colors.amber : null,
                          ),
                        )),
                        DataCell(Text('${contributor.reposContributed}')),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFFD700).withOpacity(0.3),
                                  Colors.orange.withOpacity(0.3),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${contributor.activityScore}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD700),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Activity Breakdown Chart
        Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📈 Contribution Breakdown',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: data.contributors.take(10).toList().asMap().entries.map((entry) {
                      final c = entry.value;
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: c.commits.toDouble(),
                            color: Colors.green,
                            width: 6,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          BarChartRodData(
                            toY: c.prsOpened.toDouble() * 3,
                            color: Colors.blue,
                            width: 6,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          BarChartRodData(
                            toY: c.prsReviewed.toDouble() * 2,
                            color: Colors.orange,
                            width: 6,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= data.contributors.take(10).length) {
                              return const SizedBox();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(
                                  data.contributors[value.toInt()].avatarUrl,
                                ),
                              ),
                            );
                          },
                          reservedSize: 40,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text('${value.toInt()}', style: const TextStyle(fontSize: 10));
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ChartLegend(color: Colors.green, label: 'Commits'),
                  const SizedBox(width: 24),
                  _ChartLegend(color: Colors.blue, label: 'PRs (×3)'),
                  const SizedBox(width: 24),
                  _ChartLegend(color: Colors.orange, label: 'Reviews (×2)'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return '$number';
  }
}

class _ContribStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ContribStatCard({
    required this.title,
    required this.value,
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
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  final String title;
  final List<Contributor> contributors;
  final String Function(Contributor) metricBuilder;
  final Color metricColor;

  const _LeaderboardCard({
    required this.title,
    required this.contributors,
    required this.metricBuilder,
    required this.metricColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ...contributors.take(5).toList().asMap().entries.map((entry) {
            final index = entry.key;
            final contributor = entry.value;
            final medal = index == 0 ? '🥇' : index == 1 ? '🥈' : index == 2 ? '🥉' : '  ';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text(medal, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(contributor.avatarUrl),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      contributor.username,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: metricColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      metricBuilder(contributor),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: metricColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _MetricBadge extends StatelessWidget {
  final int value;
  final Color color;

  const _MetricBadge({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    if (value == 0) {
      return Text('$value', style: TextStyle(color: Colors.grey[600]));
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$value',
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}