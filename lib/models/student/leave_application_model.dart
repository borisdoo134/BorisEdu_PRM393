class LeaveApplicationModel {
  final String id;
  final String studentId;
  final String startDate;
  final String endDate;
  final String reason;
  final String status;
  final String createdAt;

  LeaveApplicationModel({
    this.id = '',
    this.studentId = '',
    this.startDate = '',
    this.endDate = '',
    this.reason = '',
    this.status = '',
    this.createdAt = '',
  });

  factory LeaveApplicationModel.fromJson(Map<String, dynamic> json) {
    return LeaveApplicationModel(
      id: json['id']?.toString() ?? '',
      studentId: json['studentId']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
      'status': status,
      'createdAt': createdAt,
    };
  }

  String get displayStatus {
    switch (status) {
      case 'PENDING':
        return 'Chờ duyệt';
      case 'APPROVED':
        return 'Đã duyệt';
      case 'REJECTED':
        return 'Từ chối';
      default:
        return status;
    }
  }
}
