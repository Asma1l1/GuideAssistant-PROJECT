import 'user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel extends UserModel {
  final String name;
  final DocumentReference advisorRef;
  final DocumentReference scheduleRef; // مرجع إلى الجدول في قاعدة البيانات
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
    required this.advisorRef,
    required this.scheduleRef, // إضافة المتغير الجديد
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
      name: data['name'] ?? 'غير متوفر',
      email: data['email'] ?? 'غير متوفر',
      type: data['type'] ?? 'STUDENT',
      advisorRef: data['advisorID'] ?? FirebaseFirestore.instance.doc('/advisors/غير_متوفر'),
      scheduleRef: data['scheduleRef'] ?? FirebaseFirestore.instance.doc('/schedules/غير_متوفر'), // تحميل مرجع الجدول
      college: data['college'] ?? 'غير متوفر',
      major: data['major'] ?? 'غير متوفر',
      gpa: double.tryParse(data['gpa']?.toString() ?? '0') ?? 0.0,
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
        'advisorID': advisorRef,
        'scheduleRef': scheduleRef, // إضافة مرجع الجدول إلى Firestore
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

