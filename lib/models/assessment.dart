import 'dart:convert';

class Assessment {
  final int assessmentId;
  final int classId;
  final String createdBy;
  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  final String? instructions;
  Assessment({
    required this.assessmentId,
    required this.classId,
    required this.createdBy,
    required this.dueDate,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.instructions,
  });

  Assessment copyWith({
    int? assessmentId,
    int? classId,
    String? createdBy,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    String? instructions,
  }) {
    return Assessment(
      assessmentId: assessmentId ?? this.assessmentId,
      classId: classId ?? this.classId,
      createdBy: createdBy ?? this.createdBy,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      instructions: instructions ?? this.instructions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'assessmentId': assessmentId,
      'classId': classId,
      'createdBy': createdBy,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastUpdatedAt': lastUpdatedAt.millisecondsSinceEpoch,
      'instructions': instructions,
    };
  }

  factory Assessment.fromMap(Map<String, dynamic> map) {
    return Assessment(
      assessmentId: map['assessmentId'] as int,
      classId: map['classId'] as int,
      createdBy: map['createdBy'] as String,
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      lastUpdatedAt:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdatedAt'] as int),
      instructions: map['instructions'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Assessment.fromJson(String source) =>
      Assessment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Assessment(assessmentId: $assessmentId, classId: $classId, createdBy: $createdBy, dueDate: $dueDate, createdAt: $createdAt, lastUpdatedAt: $lastUpdatedAt, instructions: $instructions)';
  }

  @override
  bool operator ==(covariant Assessment other) {
    if (identical(this, other)) return true;

    return other.assessmentId == assessmentId &&
        other.classId == classId &&
        other.createdBy == createdBy &&
        other.dueDate == dueDate &&
        other.createdAt == createdAt &&
        other.lastUpdatedAt == lastUpdatedAt &&
        other.instructions == instructions;
  }

  @override
  int get hashCode {
    return assessmentId.hashCode ^
        classId.hashCode ^
        createdBy.hashCode ^
        dueDate.hashCode ^
        createdAt.hashCode ^
        lastUpdatedAt.hashCode ^
        instructions.hashCode;
  }
}
