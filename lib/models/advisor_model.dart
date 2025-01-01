import 'user_model.dart';

class AdvisorModel extends UserModel {
  final String username;
  final String department;
  final int studentsCount;

  AdvisorModel({
    required String id,
    required String email,
    required String type,
    required this.username,
    required this.department,
    required this.studentsCount,
  }) : super(id: id, email: email, type: type);

  factory AdvisorModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AdvisorModel(
      id: id,
      email: data['email'] ?? '',
      type: data['type'] ?? 'ADVISOR',
      username: data['username'] ?? '',
      department: data['department'] ?? '',
      studentsCount: data['studentsCount'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return super.toFirestore()
      ..addAll({
        'username': username,
        'department': department,
        'studentsCount': studentsCount,
      });
  }
}
