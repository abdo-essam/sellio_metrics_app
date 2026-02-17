// lib/models/metrics_models.dart

class MetricsSummary {
  final int totalRepos;
  final int totalOpenPRs;
  final int totalOpenIssues;
  final int totalClosedIssues;
  final int totalCommitsLast30Days;
  final double issueResolutionRate;
  final DateTime fetchedAt;

  MetricsSummary({
    required this.totalRepos,
    required this.totalOpenPRs,
    required this.totalOpenIssues,
    required this.totalClosedIssues,
    required this.totalCommitsLast30Days,
    required this.issueResolutionRate,
    required this.fetchedAt,
  });

  factory MetricsSummary.fromJson(Map<String, dynamic> json) {
    return MetricsSummary(
      totalRepos: json['totalRepos'] ?? 0,
      totalOpenPRs: json['totalOpenPRs'] ?? 0,
      totalOpenIssues: json['totalOpenIssues'] ?? 0,
      totalClosedIssues: json['totalClosedIssues'] ?? 0,
      totalCommitsLast30Days: json['totalCommitsLast30Days'] ?? 0,
      issueResolutionRate: double.tryParse(json['issueResolutionRate']?.toString() ?? '0') ?? 0,
      fetchedAt: DateTime.parse(json['fetchedAt']),
    );
  }
}

class CommitVelocity {
  final List<DailyCommit> dailyCommits;
  final List<WeeklyCommit> weeklyCommits;
  final List<AuthorCommit> commitsByAuthor;
  final List<RepoCommit> commitsByRepo;
  final double averagePerDay;
  final double velocityChange;
  final int totalCommits;

  CommitVelocity({
    required this.dailyCommits,
    required this.weeklyCommits,
    required this.commitsByAuthor,
    required this.commitsByRepo,
    required this.averagePerDay,
    required this.velocityChange,
    required this.totalCommits,
  });

  factory CommitVelocity.fromJson(Map<String, dynamic> json) {
    return CommitVelocity(
      dailyCommits: (json['dailyCommits'] as List)
          .map((e) => DailyCommit.fromJson(e))
          .toList(),
      weeklyCommits: (json['weeklyCommits'] as List)
          .map((e) => WeeklyCommit.fromJson(e))
          .toList(),
      commitsByAuthor: (json['commitsByAuthor'] as List)
          .map((e) => AuthorCommit.fromJson(e))
          .toList(),
      commitsByRepo: (json['commitsByRepo'] as List)
          .map((e) => RepoCommit.fromJson(e))
          .toList(),
      averagePerDay: double.tryParse(json['averagePerDay']?.toString() ?? '0') ?? 0,
      velocityChange: (json['velocityChange'] ?? 0).toDouble(),
      totalCommits: json['totalCommits'] ?? 0,
    );
  }
}

class DailyCommit {
  final String date;
  final int count;

  DailyCommit({required this.date, required this.count});

  factory DailyCommit.fromJson(Map<String, dynamic> json) {
    return DailyCommit(
      date: json['date'],
      count: json['count'],
    );
  }
}

class WeeklyCommit {
  final String week;
  final int count;

  WeeklyCommit({required this.week, required this.count});

  factory WeeklyCommit.fromJson(Map<String, dynamic> json) {
    return WeeklyCommit(
      week: json['week'],
      count: json['count'],
    );
  }
}

class AuthorCommit {
  final String author;
  final int count;

  AuthorCommit({required this.author, required this.count});

  factory AuthorCommit.fromJson(Map<String, dynamic> json) {
    return AuthorCommit(
      author: json['author'],
      count: json['count'],
    );
  }
}

class RepoCommit {
  final String repo;
  final int count;

  RepoCommit({required this.repo, required this.count});

  factory RepoCommit.fromJson(Map<String, dynamic> json) {
    return RepoCommit(
      repo: json['repo'],
      count: json['count'],
    );
  }
}

class PRReviewTimes {
  final PRReviewSummary summary;
  final List<RepoReviewTime> byRepo;
  final List<AuthorReviewTime> byAuthor;
  final PRDistribution distribution;

  PRReviewTimes({
    required this.summary,
    required this.byRepo,
    required this.byAuthor,
    required this.distribution,
  });

  factory PRReviewTimes.fromJson(Map<String, dynamic> json) {
    return PRReviewTimes(
      summary: PRReviewSummary.fromJson(json['summary']),
      byRepo: (json['byRepo'] as List)
          .map((e) => RepoReviewTime.fromJson(e))
          .toList(),
      byAuthor: (json['byAuthor'] as List)
          .map((e) => AuthorReviewTime.fromJson(e))
          .toList(),
      distribution: PRDistribution.fromJson(json['distribution']),
    );
  }
}

class PRReviewSummary {
  final int totalMerged;
  final int totalOpen;
  final double averageHoursToMerge;
  final double medianHoursToMerge;

  PRReviewSummary({
    required this.totalMerged,
    required this.totalOpen,
    required this.averageHoursToMerge,
    required this.medianHoursToMerge,
  });

  factory PRReviewSummary.fromJson(Map<String, dynamic> json) {
    return PRReviewSummary(
      totalMerged: json['totalMerged'] ?? 0,
      totalOpen: json['totalOpen'] ?? 0,
      averageHoursToMerge: double.tryParse(json['averageHoursToMerge']?.toString() ?? '0') ?? 0,
      medianHoursToMerge: double.tryParse(json['medianHoursToMerge']?.toString() ?? '0') ?? 0,
    );
  }
}

class RepoReviewTime {
  final String repo;
  final double average;
  final double median;
  final int count;

  RepoReviewTime({
    required this.repo,
    required this.average,
    required this.median,
    required this.count,
  });

  factory RepoReviewTime.fromJson(Map<String, dynamic> json) {
    return RepoReviewTime(
      repo: json['repo'],
      average: double.tryParse(json['average']?.toString() ?? '0') ?? 0,
      median: double.tryParse(json['median']?.toString() ?? '0') ?? 0,
      count: json['count'] ?? 0,
    );
  }
}

class AuthorReviewTime {
  final String author;
  final double averageHours;
  final int prCount;

  AuthorReviewTime({
    required this.author,
    required this.averageHours,
    required this.prCount,
  });

  factory AuthorReviewTime.fromJson(Map<String, dynamic> json) {
    return AuthorReviewTime(
      author: json['author'],
      averageHours: double.tryParse(json['averageHours']?.toString() ?? '0') ?? 0,
      prCount: json['prCount'] ?? 0,
    );
  }
}

class PRDistribution {
  final int under1Hour;
  final int under4Hours;
  final int under24Hours;
  final int under72Hours;
  final int over72Hours;

  PRDistribution({
    required this.under1Hour,
    required this.under4Hours,
    required this.under24Hours,
    required this.under72Hours,
    required this.over72Hours,
  });

  factory PRDistribution.fromJson(Map<String, dynamic> json) {
    return PRDistribution(
      under1Hour: json['under1Hour'] ?? 0,
      under4Hours: json['under4Hours'] ?? 0,
      under24Hours: json['under24Hours'] ?? 0,
      under72Hours: json['under72Hours'] ?? 0,
      over72Hours: json['over72Hours'] ?? 0,
    );
  }
}

class IssueResolution {
  final IssueResolutionSummary summary;
  final List<RepoResolution> byRepo;
  final List<AssigneeResolution> byAssignee;
  final List<LabelCount> byLabel;

  IssueResolution({
    required this.summary,
    required this.byRepo,
    required this.byAssignee,
    required this.byLabel,
  });

  factory IssueResolution.fromJson(Map<String, dynamic> json) {
    return IssueResolution(
      summary: IssueResolutionSummary.fromJson(json['summary']),
      byRepo: (json['byRepo'] as List)
          .map((e) => RepoResolution.fromJson(e))
          .toList(),
      byAssignee: (json['byAssignee'] as List)
          .map((e) => AssigneeResolution.fromJson(e))
          .toList(),
      byLabel: (json['byLabel'] as List)
          .map((e) => LabelCount.fromJson(e))
          .toList(),
    );
  }
}

class IssueResolutionSummary {
  final int totalOpen;
  final int totalClosed;
  final double overallResolutionRate;
  final double averageResolutionHours;

  IssueResolutionSummary({
    required this.totalOpen,
    required this.totalClosed,
    required this.overallResolutionRate,
    required this.averageResolutionHours,
  });

  factory IssueResolutionSummary.fromJson(Map<String, dynamic> json) {
    return IssueResolutionSummary(
      totalOpen: json['totalOpen'] ?? 0,
      totalClosed: json['totalClosed'] ?? 0,
      overallResolutionRate: double.tryParse(json['overallResolutionRate']?.toString() ?? '0') ?? 0,
      averageResolutionHours: double.tryParse(json['averageResolutionHours']?.toString() ?? '0') ?? 0,
    );
  }
}

class RepoResolution {
  final String repo;
  final int open;
  final int closed;
  final double resolutionRate;
  final double? averageHours;

  RepoResolution({
    required this.repo,
    required this.open,
    required this.closed,
    required this.resolutionRate,
    this.averageHours,
  });

  factory RepoResolution.fromJson(Map<String, dynamic> json) {
    return RepoResolution(
      repo: json['repo'],
      open: json['open'] ?? 0,
      closed: json['closed'] ?? 0,
      resolutionRate: double.tryParse(json['resolutionRate']?.toString() ?? '0') ?? 0,
      averageHours: json['averageHours'] != null
          ? double.tryParse(json['averageHours'].toString())
          : null,
    );
  }
}

class AssigneeResolution {
  final String assignee;
  final int closed;
  final int open;
  final double resolutionRate;
  final double? averageHours;

  AssigneeResolution({
    required this.assignee,
    required this.closed,
    required this.open,
    required this.resolutionRate,
    this.averageHours,
  });

  factory AssigneeResolution.fromJson(Map<String, dynamic> json) {
    return AssigneeResolution(
      assignee: json['assignee'],
      closed: json['closed'] ?? 0,
      open: json['open'] ?? 0,
      resolutionRate: double.tryParse(json['resolutionRate']?.toString() ?? '0') ?? 0,
      averageHours: json['averageHours'] != null
          ? double.tryParse(json['averageHours'].toString())
          : null,
    );
  }
}

class LabelCount {
  final String label;
  final int count;

  LabelCount({required this.label, required this.count});

  factory LabelCount.fromJson(Map<String, dynamic> json) {
    return LabelCount(
      label: json['label'],
      count: json['count'],
    );
  }
}

class ContributorStats {
  final List<Contributor> contributors;
  final ContributorSummary summary;
  final List<Contributor> topCommitters;
  final List<Contributor> topReviewers;
  final List<Contributor> topByActivity;

  ContributorStats({
    required this.contributors,
    required this.summary,
    required this.topCommitters,
    required this.topReviewers,
    required this.topByActivity,
  });

  factory ContributorStats.fromJson(Map<String, dynamic> json) {
    return ContributorStats(
      contributors: (json['contributors'] as List)
          .map((e) => Contributor.fromJson(e))
          .toList(),
      summary: ContributorSummary.fromJson(json['summary']),
      topCommitters: (json['topCommitters'] as List)
          .map((e) => Contributor.fromJson(e))
          .toList(),
      topReviewers: (json['topReviewers'] as List)
          .map((e) => Contributor.fromJson(e))
          .toList(),
      topByActivity: (json['topByActivity'] as List)
          .map((e) => Contributor.fromJson(e))
          .toList(),
    );
  }
}

class Contributor {
  final String username;
  final String avatarUrl;
  final int commits;
  final int additions;
  final int deletions;
  final int linesChanged;
  final int prsOpened;
  final int prsMerged;
  final int prsReviewed;
  final int issuesOpened;
  final int issuesClosed;
  final int reposContributed;
  final int activityScore;

  Contributor({
    required this.username,
    required this.avatarUrl,
    required this.commits,
    required this.additions,
    required this.deletions,
    required this.linesChanged,
    required this.prsOpened,
    required this.prsMerged,
    required this.prsReviewed,
    required this.issuesOpened,
    required this.issuesClosed,
    required this.reposContributed,
    required this.activityScore,
  });

  factory Contributor.fromJson(Map<String, dynamic> json) {
    return Contributor(
      username: json['username'],
      avatarUrl: json['avatarUrl'],
      commits: json['commits'] ?? 0,
      additions: json['additions'] ?? 0,
      deletions: json['deletions'] ?? 0,
      linesChanged: json['linesChanged'] ?? 0,
      prsOpened: json['prsOpened'] ?? 0,
      prsMerged: json['prsMerged'] ?? 0,
      prsReviewed: json['prsReviewed'] ?? 0,
      issuesOpened: json['issuesOpened'] ?? 0,
      issuesClosed: json['issuesClosed'] ?? 0,
      reposContributed: json['reposContributed'] ?? 0,
      activityScore: json['activityScore'] ?? 0,
    );
  }
}

class ContributorSummary {
  final int totalContributors;
  final int totalCommits;
  final int totalPRs;
  final int totalReviews;
  final int totalIssuesClosed;

  ContributorSummary({
    required this.totalContributors,
    required this.totalCommits,
    required this.totalPRs,
    required this.totalReviews,
    required this.totalIssuesClosed,
  });

  factory ContributorSummary.fromJson(Map<String, dynamic> json) {
    return ContributorSummary(
      totalContributors: json['totalContributors'] ?? 0,
      totalCommits: json['totalCommits'] ?? 0,
      totalPRs: json['totalPRs'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      totalIssuesClosed: json['totalIssuesClosed'] ?? 0,
    );
  }
}