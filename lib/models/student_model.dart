import 'user_model.dart';


class StudentModel extends UserModel {
  final String name;
  final String advisorID;
  final String college;
  final String major;
  final double gpa;
  final int level;
  final int completedHours;
  final int registeredHours;
  final int remainingHours;

  StudentModel({
    required super.id,
    required this.name,

    required super.email,
    required super.type,
    required this.advisorID,
    required this.college,
    required this.major,
    required this.gpa,
    required this.level,
    required this.completedHours,
    required this.registeredHours,
    required this.remainingHours,
  });

  factory StudentModel.fromFirestore(Map<String, dynamic> data, String id) {
    return StudentModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      type: data['type'] ?? 'STUDENT',
      advisorID: data['advisorID'] ?? '',
      college: data['college'] ?? '',
      major: data['major'] ?? '',
      gpa: double.tryParse(data['gpa'].toString()) ?? 0.0,
      level: data['level'] ?? 0,
      completedHours: data['completedHours'] ?? 0,
      registeredHours: data['registeredHours'] ?? 0,
      remainingHours: data['remainingHours'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return super.toFirestore()
      ..addAll({
        'name': name,
        'advisorID': advisorID,
        'college': college,
        'major': major,
        'gpa': gpa,
        'level': level,
        'completedHours': completedHours,
        'registeredHours': registeredHours,
        'remainingHours': remainingHours,
      });
  }
}
