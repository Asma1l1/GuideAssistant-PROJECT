import 'package:cloud_firestore/cloud_firestore.dart';

import 'section_model.dart';

class CourseModel {
  final String courseCode;
  final DocumentReference courseRef;
  final String semester;
  final List<SectionModel> sections;
  final int level;

  CourseModel({
    required this.courseCode,
    required this.courseRef,
    required this.semester,
    required this.sections,
    required this.level,
  });

  Map<String, dynamic> toMap() => {
        'courseCode': courseCode,
        'courseRef': courseRef.path,
        'semester': semester,
        'level': level,
        'sections': {
          for (var section in sections) section.name: section.toMap()
        },
      };

  factory CourseModel.fromMap(Map<String, dynamic> data) {
    return CourseModel(
      courseCode: data['courseCode'],
      courseRef: FirebaseFirestore.instance.doc(data['courseRef']),
      semester: data['semester'],
      level: data['level'],
      sections: (data['sections'] as Map<String, dynamic>?)
              ?.entries
              .map((entry) {
            return SectionModel.fromMap(entry.value as Map<String, dynamic>);
          }).toList() ??
          [],
    );
  }

  factory CourseModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CourseModel(
      courseCode: id,
      courseRef: data['courseRef'] as DocumentReference,
      semester: data['semester'],
      level: data['level'],
      sections:
          (data['sections'] as Map<String, dynamic>?)?.entries.map((entry) {
                return SectionModel.fromFirestore(
                    entry.value as Map<String, dynamic>, entry.key);
              }).toList() ??
              [],
    );
  }
}
