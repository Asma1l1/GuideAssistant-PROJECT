class UserModel {
  final String id;
  final String email;
  final String name;
  final String type;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.type,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      type: data['type'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'type': type,
    };
  }
}
