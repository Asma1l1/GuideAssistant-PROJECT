import 'user_model.dart';

class AdvisorModel extends UserModel {
  final String first_name;
  final String last_name;
  final String department;
  final int studentsCount;

  AdvisorModel({
    required String id,
    required String email,
    required String type,
    required this.last_name,
    required this.first_name,
    required this.department,
    required this.studentsCount,
  }) : super(id: id, email: email, type: type);

  factory AdvisorModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AdvisorModel(
      id: id,
      email: data['email'] ?? '',
      type: data['type'] ?? 'ADVISOR',
      first_name: data['firstName'] ?? '',
      last_name: data['lastName'] ?? '',
      department: data['department'] ?? '',
      studentsCount: data['studentsCount'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return super.toFirestore()
      ..addAll({
        'first name': first_name,
        'last name': last_name,
        
        'department': department,
        'studentsCount': studentsCount,
      });
  }
}
