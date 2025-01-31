class SectionModel {
  final String name;
  final String instructor;
  final String location;
  final String schedule;
  final String type;

  SectionModel({
    required this.name,
    required this.instructor,
    required this.location,
    required this.schedule,
    required this.type,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'instructor': instructor,
        'location': location,
        'schedule': schedule,
        'type': type,
      };

  factory SectionModel.fromMap(Map<String, dynamic> data) {
    return SectionModel(
      name: data['name'],
      instructor: data['instructor'] ?? '',
      location: data['location'] ?? '',
      schedule: data['schedule'] ?? '',
      type: data['type'] ?? '',
    );
  }

  factory SectionModel.fromFirestore(Map<String, dynamic> data, String id) {
    return SectionModel(
      name: id,
      instructor: data['instructor'] ?? '',
      location: data['location'] ?? '',
      schedule: (data['schedule'] != null)
          ? '${data['schedule']['day'] ?? ''} ${data['schedule']['time'] ?? ''}'
          : '',
      type: data['type'] ?? '',
    );
  }
}
