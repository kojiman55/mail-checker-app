enum Language { ja, en }

enum IssueType { error, warning, info }

class ReviewIssue {
  final IssueType type;
  final String original;
  final String suggestion;
  final String reason;

  ReviewIssue({
    required this.type,
    required this.original,
    required this.suggestion,
    required this.reason,
  });

  factory ReviewIssue.fromJson(Map<String, dynamic> json) {
    return ReviewIssue(
      type: json['type'] == 'error'
          ? IssueType.error
          : json['type'] == 'warning'
              ? IssueType.warning
              : IssueType.info,
      original: json['original'] ?? '',
      suggestion: json['suggestion'] ?? '',
      reason: json['reason'] ?? '',
    );
  }
}

class ReviewResponse {
  final String? correctedText;
  final List<ReviewIssue> issues;
  final String? summary;

  ReviewResponse({
    this.correctedText,
    required this.issues,
    this.summary,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      correctedText: json['correctedText'],
      issues: (json['issues'] as List<dynamic>? ?? [])
          .map((e) => ReviewIssue.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: json['summary'],
    );
  }
}
