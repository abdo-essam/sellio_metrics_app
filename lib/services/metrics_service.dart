// lib/services/metrics_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/metrics_models.dart';

class MetricsService {
  final String baseUrl;

  MetricsService({this.baseUrl = 'http://192.168.1.18:3000'});

  Future<MetricsSummary> getSummary() async {
    final response = await http.get(Uri.parse('$baseUrl/api/metrics/summary'));
    if (response.statusCode == 200) {
      return MetricsSummary.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load summary');
  }

  Future<CommitVelocity> getCommitVelocity({int days = 30}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/metrics/commit-velocity?days=$days'),
    );
    if (response.statusCode == 200) {
      return CommitVelocity.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load commit velocity');
  }

  Future<PRReviewTimes> getPRReviewTimes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/metrics/pr-review-times'),
    );
    if (response.statusCode == 200) {
      return PRReviewTimes.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load PR review times');
  }

  Future<IssueResolution> getIssueResolution() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/metrics/issue-resolution'),
    );
    if (response.statusCode == 200) {
      return IssueResolution.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load issue resolution');
  }

  Future<ContributorStats> getContributorStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/metrics/contributors'),
    );
    if (response.statusCode == 200) {
      return ContributorStats.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load contributor stats');
  }
}