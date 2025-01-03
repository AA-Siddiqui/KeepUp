import 'dart:convert';

class Class {
  final int classId;
  final String subjectName;
  final String program;
  final int semester;
  final String section;
  final String teacher;
  final String term;
  Class({
    required this.classId,
    required this.subjectName,
    required this.program,
    required this.semester,
    required this.section,
    required this.teacher,
    required this.term,
  });

  Class copyWith({
    int? classId,
    String? subjectName,
    String? program,
    int? semester,
    String? section,
    String? teacher,
    String? term,
  }) {
    return Class(
      classId: classId ?? this.classId,
      subjectName: subjectName ?? this.subjectName,
      program: program ?? this.program,
      semester: semester ?? this.semester,
      section: section ?? this.section,
      teacher: teacher ?? this.teacher,
      term: term ?? this.term,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'classId': classId,
      'subjectName': subjectName,
      'program': program,
      'semester': semester,
      'section': section,
      'teacher': teacher,
      'term': term,
    };
  }

  factory Class.fromMap(Map<String, dynamic> map) {
    return Class(
      classId: map['classId'] as int,
      subjectName: map['subjectName'] as String,
      program: map['program'] as String,
      semester: map['semester'] as int,
      section: map['section'] as String,
      teacher: map['teacher'] as String,
      term: map['term'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Class.fromJson(String source) =>
      Class.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Class(classId: $classId, subjectName: $subjectName, program: $program, semester: $semester, section: $section, teacher: $teacher, term: $term)';
  }

  @override
  bool operator ==(covariant Class other) {
    if (identical(this, other)) return true;

    return other.classId == classId &&
        other.subjectName == subjectName &&
        other.program == program &&
        other.semester == semester &&
        other.section == section &&
        other.teacher == teacher &&
        other.term == term;
  }

  @override
  int get hashCode {
    return classId.hashCode ^
        subjectName.hashCode ^
        program.hashCode ^
        semester.hashCode ^
        section.hashCode ^
        teacher.hashCode ^
        term.hashCode;
  }
}
