import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  final DocumentReference courseRef; // مرجع المادة الدراسية
  final String courseName; // اسم المادة الدراسية
  final String courseCode; // رمز المادة
  final int creditHours; // عدد الساعات
  final int section; // رقم الشعبة
  final String instructor; // اسم المدرس
  final String location; // الموقع
  final int capacity; // السعة
  final int enrolledStudents; // عدد الطلاب المسجلين
  final String day; // اليوم
  final String time; // الوقت
  final String type; // نوع المادة (نظري/عملي)

  ScheduleModel({
    required this.courseRef,
    required this.courseName,
    required this.courseCode,
    required this.creditHours,
    required this.section,
    required this.instructor,
    required this.location,
    required this.capacity,
    required this.enrolledStudents,
    required this.day,
    required this.time,
    required this.type,
  });

  // تحويل بيانات Firestore إلى كائن Dart
  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      courseRef: map['courseRef'] ?? FirebaseFirestore.instance.doc('/courses/غير_متوفر'),
      courseName: map['courseName'] ?? 'غير متوفر',
      courseCode: map['courseCode'] ?? 'غير متوفر',
      creditHours: map['creditHours'] ?? 0,
      section: map['section'] ?? 0,
      instructor: map['instructor'] ?? 'غير متوفر',
      location: map['location'] ?? 'غير متوفر',
      capacity: map['capacity'] ?? 0,
      enrolledStudents: map['enrolledStudents'] ?? 0,
      day: map['schedule']?['day'] ?? 'غير متوفر',
      time: map['schedule']?['time'] ?? 'غير متوفر',
      type: map['type'] ?? 'غير متوفر',
    );
  }

  // تحويل كائن Dart إلى Map لحفظه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'courseRef': courseRef,
      'courseName': courseName,
      'courseCode': courseCode,
      'creditHours': creditHours,
      'section': section,
      'instructor': instructor,
      'location': location,
      'capacity': capacity,
      'enrolledStudents': enrolledStudents,
      'schedule': {
        'day': day,
        'time': time,
      },
      'type': type,
    };
  }
}
