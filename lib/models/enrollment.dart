import 'dart:convert';

class Enrollment {
  final int enrollmentId;
  final int classId;
  final String userId;
  Enrollment({
    required this.enrollmentId,
    required this.classId,
    required this.userId,
  });

  Enrollment copyWith({
    int? enrollmentId,
    int? classId,
    String? userId,
  }) {
    return Enrollment(
      enrollmentId: enrollmentId ?? this.enrollmentId,
      classId: classId ?? this.classId,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'enrollmentId': enrollmentId,
      'classId': classId,
      'userId': userId,
    };
  }

  factory Enrollment.fromMap(Map<String, dynamic> map) {
    return Enrollment(
      enrollmentId: map['enrollmentId'] as int,
      classId: map['classId'] as int,
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Enrollment.fromJson(String source) =>
      Enrollment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Enrollment(enrollmentId: $enrollmentId, classId: $classId, userId: $userId)';

  @override
  bool operator ==(covariant Enrollment other) {
    if (identical(this, other)) return true;

    return other.enrollmentId == enrollmentId &&
        other.classId == classId &&
        other.userId == userId;
  }

  @override
  int get hashCode =>
      enrollmentId.hashCode ^ classId.hashCode ^ userId.hashCode;
}
