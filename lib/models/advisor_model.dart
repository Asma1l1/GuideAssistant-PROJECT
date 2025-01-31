import 'user_model.dart';

class AdvisorModel extends UserModel {
  final String department;
  final int studentsCount;

  AdvisorModel({
    required super.id,
    required super.email,
    required super.name,
    required super.type,
    required this.department,
    required this.studentsCount,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'type': type,
        'name': name,
        'department': department,
        'studentsCount': studentsCount,
      };

  factory AdvisorModel.fromMap(Map<String, dynamic> data) {
    return AdvisorModel(
      id: data['id'],
      email: data['email'],
      type: data['type'],
      name: data['name'],
      department: data['department'],
      studentsCount: data['studentsCount'],
    );
  }

  factory AdvisorModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AdvisorModel(
      id: id,
      email: data['email'] ?? '',
      type: data['type'] ?? 'ADVISOR',
      name: data['name'] ?? '',
      department: data['department'] ?? '',
      studentsCount: data['studentsCount'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return super.toFirestore()
      ..addAll({
        'name': name,
        'department': department,
        'studentsCount': studentsCount,
      });
  }
}
