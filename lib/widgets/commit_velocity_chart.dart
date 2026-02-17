// lib/widgets/commit_velocity_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/metrics_models.dart';

class CommitVelocityChart extends StatelessWidget {
  final CommitVelocity data;

  const CommitVelocityChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Velocity Stats Row
        Row(
          children: [
            _StatCard(
              title: 'Total Commits',
              value: '${data.totalCommits}',
              icon: Icons.commit,
            ),
            const SizedBox(width: 16),
            _StatCard(
              title: 'Daily Average',
              value: '${data.averagePerDay}',
              icon: Icons.trending_up,
            ),
            const SizedBox(width: 16),
            _StatCard(
              title: 'Week vs Week',
              value:
                  '${data.velocityChange > 0 ? '+' : ''}${data.velocityChange}%',
              icon: data.velocityChange >= 0
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              valueColor: data.velocityChange >= 0 ? Colors.green : Colors.red,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Daily Commits Chart
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
                'Daily Commits (Last 30 Days)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BarChart(
                  BarChartData(
                    barGroups: data.dailyCommits.asMap().entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.count.toDouble(),
                            color: const Color(0xFF6366F1),
                            width: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() % 5 != 0) return const SizedBox();
                            final date = data.dailyCommits[value.toInt()].date;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                date.substring(5),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 5,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.2),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Commits by Author & Repo
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // By Author
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '👤 Commits by Author',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    ...data.commitsByAuthor.take(10).map((author) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(
                                  'https://github.com/${author.author}.png',
                                ),
                                onBackgroundImageError: (_, __) {},
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      author.author,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 4),
                                    LinearProgressIndicator(
                                      value: author.count /
                                          (data.commitsByAuthor.first.count),
                                      backgroundColor: Colors.grey[800],
                                      valueColor: const AlwaysStoppedAnimation(
                                          Color(0xFF6366F1)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${author.count}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6366F1),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),

            // By Repo
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📁 Commits by Repository',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    ...data.commitsByRepo.take(10).map((repo) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.folder,
                                  size: 20, color: Colors.amber),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      repo.repo,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    LinearProgressIndicator(
                                      value: repo.count /
                                          (data.commitsByRepo.first.count),
                                      backgroundColor: Colors.grey[800],
                                      valueColor: const AlwaysStoppedAnimation(
                                          Colors.amber),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${repo.count}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.valueColor,
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
        child: Row(
          children: [
            Icon(icon, color: valueColor ?? const Color(0xFF6366F1)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? Colors.white,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
