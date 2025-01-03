import 'dart:convert';

class AssessmentStatus {
  final int assessmentStatusId;
  final int assessmentId;
  final String userId;
  final DateTime? doneAt;
  AssessmentStatus({
    required this.assessmentStatusId,
    required this.assessmentId,
    required this.userId,
    this.doneAt,
  });

  AssessmentStatus copyWith({
    int? assessmentStatusId,
    int? assessmentId,
    String? userId,
    DateTime? doneAt,
  }) {
    return AssessmentStatus(
      assessmentStatusId: assessmentStatusId ?? this.assessmentStatusId,
      assessmentId: assessmentId ?? this.assessmentId,
      userId: userId ?? this.userId,
      doneAt: doneAt ?? this.doneAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'assessmentStatusId': assessmentStatusId,
      'assessmentId': assessmentId,
      'userId': userId,
      'doneAt': doneAt?.millisecondsSinceEpoch,
    };
  }

  factory AssessmentStatus.fromMap(Map<String, dynamic> map) {
    return AssessmentStatus(
      assessmentStatusId: map['assessmentStatusId'] as int,
      assessmentId: map['assessmentId'] as int,
      userId: map['userId'] as String,
      doneAt: map['doneAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['doneAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssessmentStatus.fromJson(String source) =>
      AssessmentStatus.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AssessmentStatus(assessmentStatusId: $assessmentStatusId, assessmentId: $assessmentId, userId: $userId, doneAt: $doneAt)';
  }

  @override
  bool operator ==(covariant AssessmentStatus other) {
    if (identical(this, other)) return true;

    return other.assessmentStatusId == assessmentStatusId &&
        other.assessmentId == assessmentId &&
        other.userId == userId &&
        other.doneAt == doneAt;
  }

  @override
  int get hashCode {
    return assessmentStatusId.hashCode ^
        assessmentId.hashCode ^
        userId.hashCode ^
        doneAt.hashCode;
  }
}
