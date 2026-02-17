// lib/providers/metrics_provider.dart

import 'package:flutter/material.dart';
import '../models/metrics_models.dart';
import '../services/metrics_service.dart';

class MetricsProvider extends ChangeNotifier {
  final MetricsService _service = MetricsService();

  MetricsSummary? summary;
  CommitVelocity? commitVelocity;
  PRReviewTimes? prReviewTimes;
  IssueResolution? issueResolution;
  ContributorStats? contributorStats;

  bool isLoading = false;
  String? error;

  Future<void> loadAllMetrics() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getSummary(),
        _service.getCommitVelocity(),
        _service.getPRReviewTimes(),
        _service.getIssueResolution(),
        _service.getContributorStats(),
      ]);

      summary = results[0] as MetricsSummary;
      commitVelocity = results[1] as CommitVelocity;
      prReviewTimes = results[2] as PRReviewTimes;
      issueResolution = results[3] as IssueResolution;
      contributorStats = results[4] as ContributorStats;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}