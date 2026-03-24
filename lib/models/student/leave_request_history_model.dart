class LeaveRequestHistoryResponse {
  final int id;
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;
  final DateTime createdAt;

  LeaveRequestHistoryResponse({
    required this.id,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.createdAt,
  });

  factory LeaveRequestHistoryResponse.fromJson(Map<String, dynamic> json) {
    return LeaveRequestHistoryResponse(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      reason: json['reason'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
