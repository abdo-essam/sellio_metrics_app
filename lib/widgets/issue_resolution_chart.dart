// lib/widgets/issue_resolution_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/metrics_models.dart';

class IssueResolutionChart extends StatelessWidget {
  final IssueResolution data;

  const IssueResolutionChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Summary Stats
        Row(
          children: [
            _IssueStatCard(
              title: 'Open Issues',
              value: '${data.summary.totalOpen}',
              icon: Icons.error_outline,
              color: Colors.orange,
            ),
            const SizedBox(width: 16),
            _IssueStatCard(
              title: 'Closed Issues',
              value: '${data.summary.totalClosed}',
              icon: Icons.check_circle_outline,
              color: Colors.green,
            ),
            const SizedBox(width: 16),
            _IssueStatCard(
              title: 'Resolution Rate',
              value: '${data.summary.overallResolutionRate}%',
              icon: Icons.speed,
              color: Colors.blue,
            ),
            const SizedBox(width: 16),
            _IssueStatCard(
              title: 'Avg Resolution Time',
              value: _formatHours(data.summary.averageResolutionHours),
              icon: Icons.timer_outlined,
              color: Colors.purple,
            ),
          ],
        ),
        const SizedBox(height: 24),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // By Repo Chart
            Expanded(
              flex: 2,
              child: Container(
                height: 400,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📊 Resolution Rate by Repository',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 100,
                          barGroups: data.byRepo.take(8).toList().asMap().entries.map((entry) {
                            final rate = entry.value.resolutionRate;
                            Color barColor;
                            if (rate >= 80) {
                              barColor = Colors.green;
                            } else if (rate >= 50) {
                              barColor = Colors.amber;
                            } else {
                              barColor = Colors.red;
                            }
                            return BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: rate,
                                  color: barColor,
                                  width: 20,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            );
                          }).toList(),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() >= data.byRepo.take(8).length) {
                                    return const SizedBox();
                                  }
                                  final repo = data.byRepo[value.toInt()].repo;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: RotatedBox(
                                      quarterTurns: -1,
                                      child: Text(
                                        repo.length > 12 ? '${repo.substring(0, 12)}...' : repo,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  );
                                },
                                reservedSize: 80,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text('${value.toInt()}%', style: const TextStyle(fontSize: 10));
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 25,
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
            ),
            const SizedBox(width: 16),

            // Labels Breakdown
            Expanded(
              child: Container(
                height: 400,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🏷️ Issues by Label',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.byLabel.take(10).length,
                        itemBuilder: (context, index) {
                          final label = data.byLabel[index];
                          final maxCount = data.byLabel.first.count;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getLabelColor(label.label).withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: _getLabelColor(label.label),
                                              ),
                                            ),
                                            child: Text(
                                              label.label,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: _getLabelColor(label.label),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${label.count}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: label.count / maxCount,
                                  backgroundColor: Colors.grey[800],
                                  valueColor: AlwaysStoppedAnimation(_getLabelColor(label.label)),
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

        // By Assignee Table
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
                '👤 Issue Resolution by Assignee',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Assignee')),
                    DataColumn(label: Text('Open'), numeric: true),
                    DataColumn(label: Text('Closed'), numeric: true),
                    DataColumn(label: Text('Resolution Rate'), numeric: true),
                    DataColumn(label: Text('Avg Time'), numeric: true),
                  ],
                  rows: data.byAssignee.take(10).map((assignee) {
                    final rate = assignee.resolutionRate;
                    Color rateColor;
                    if (rate >= 80) {
                      rateColor = Colors.green;
                    } else if (rate >= 50) {
                      rateColor = Colors.amber;
                    } else {
                      rateColor = Colors.red;
                    }

                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              if (assignee.assignee != 'Unassigned')
                                CircleAvatar(
                                  radius: 14,
                                  backgroundImage: NetworkImage(
                                    'https://github.com/${assignee.assignee}.png',
                                  ),
                                )
                              else
                                const CircleAvatar(
                                  radius: 14,
                                  child: Icon(Icons.person_off, size: 14),
                                ),
                              const SizedBox(width: 8),
                              Text(assignee.assignee),
                            ],
                          ),
                        ),
                        DataCell(Text(
                          '${assignee.open}',
                          style: TextStyle(color: assignee.open > 0 ? Colors.orange : null),
                        )),
                        DataCell(Text(
                          '${assignee.closed}',
                          style: const TextStyle(color: Colors.green),
                        )),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: rateColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${assignee.resolutionRate}%',
                              style: TextStyle(color: rateColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        DataCell(Text(
                          assignee.averageHours != null ? _formatHours(assignee.averageHours!) : '-',
                        )),
                      ],
                    );
                  }).toList(),
                ),
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

  Color _getLabelColor(String label) {
    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('bug')) return Colors.red;
    if (lowerLabel.contains('feature')) return Colors.green;
    if (lowerLabel.contains('enhancement')) return Colors.blue;
    if (lowerLabel.contains('documentation')) return Colors.purple;
    if (lowerLabel.contains('help')) return Colors.orange;
    if (lowerLabel.contains('good first')) return Colors.teal;
    if (lowerLabel.contains('priority')) return Colors.pink;
    return Colors.grey;
  }
}

class _IssueStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _IssueStatCard({
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
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
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