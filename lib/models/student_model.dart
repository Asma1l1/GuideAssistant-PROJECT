import 'user_model.dart';


class StudentModel extends UserModel {
  final String advisorUsername;
  final String college;
  final String major;
  final double gpa;
  final int level;
  final int completedHours;
  final int registeredHours;
  final int remainingHours;

  StudentModel({
    required String id,
    required String email,
    required String type,
    required this.advisorUsername,
    required this.college,
    required this.major,
    required this.gpa,
    required this.level,
    required this.completedHours,
    required this.registeredHours,
    required this.remainingHours,
  }) : super(id: id, email: email, type: type);

  factory StudentModel.fromFirestore(Map<String, dynamic> data, String id) {
    return StudentModel(
      id: id,
      email: data['email'] ?? '',
      type: data['type'] ?? 'STUDENT',
      advisorUsername: data['advisorUsername'] ?? '',
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
        'advisorUsername': advisorUsername,
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
