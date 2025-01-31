import 'user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel extends UserModel {
  final int studentNumber;
  final DocumentReference advisorRef;
  final DocumentReference scheduleRef; // مرجع إلى الجدول في قاعدة البيانات
  final String academicDegree;
  final String generalSituation;
  final int planHours;
  final String studentStatus;
  final String studyType;
  final String college;
  final String major;
  final double gpa;
  final int level;
  final String semester;
  final int completedHours;
  final int registeredHours;
  final int remainingHours;

  StudentModel({
    required super.id,
    required super.email,
    required super.type,
    required super.name,
    required this.academicDegree,
    required this.generalSituation,
    required this.planHours,
    required this.studentStatus,
    required this.studyType,
    required this.studentNumber,
    required this.advisorRef,
    required this.scheduleRef, // إضافة المتغير الجديد
    required this.college,
    required this.major,
    required this.gpa,
    required this.level,
    required this.semester,
    required this.completedHours,
    required this.registeredHours,
    required this.remainingHours,
  });

  factory StudentModel.fromFirestore(Map<String, dynamic> data, String id) {
    // Log the entire data map for debugging
    print('Firestore Data: $data');

    // Log specific fields to check their values
    print('Name: ${data['name']}');
    print('Email: ${data['email']}');
    print('Student Number: ${data['Student_number']}');
    print('GPA: ${data['gpa']}');

    return StudentModel(
      id: id,
      studentNumber: data['Student_number'] ?? 0,
      name: data['name'] ?? 'غير متوفر',
      email: data['email'] ?? 'غير متوفر',
      type: data['type'] ?? 'STUDENT',
      advisorRef: data['advisorID'] ??
          FirebaseFirestore.instance.doc('/advisors/غير_متوفر'),
      scheduleRef: data['scheduleRef'] ??
          FirebaseFirestore.instance.doc('/schedules/غير_متوفر'),
      college: data['college'] ?? 'غير متوفر',
      major: data['major'] ?? 'غير متوفر',
      gpa: double.tryParse(data['gpa']?.toString() ?? '0') ?? 0.0,
      level: data['level'] ?? 0,
      semester: data['semester'] ?? '',
      completedHours: data['completedHours'] ?? 0,
      registeredHours: data['registeredHours'] ?? 0,
      remainingHours: data['remainingHours'] ?? 0,
      academicDegree: data['Academic_degree'] ?? '',
      generalSituation: data['General_situation'] ?? '',
      planHours: data['Plan_hours'] ?? 0,
      studentStatus: data['Student_status'] ?? '',
      studyType: data['Study_type'] ?? '',
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
        'semester': semester,
        'Academic_degree': academicDegree,
        'General_situation': generalSituation,
        'Plan_hours': planHours,
        'Student_status': studentStatus,
        'Study_type': studyType,
        'Student_number': studentNumber,
      });
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'type': type,
        'name': name,
        'studentNumber': studentNumber,
        'advisorRef': advisorRef.path,
        'scheduleRef': scheduleRef.path,
        'academicDegree': academicDegree,
        'generalSituation': generalSituation,
        'planHours': planHours,
        'studentStatus': studentStatus,
        'studyType': studyType,
        'college': college,
        'major': major,
        'gpa': gpa,
        'level': level,
        'semester': semester,
        'completedHours': completedHours,
        'registeredHours': registeredHours,
        'remainingHours': remainingHours,
      };

  factory StudentModel.fromMap(Map<String, dynamic> data) {
    return StudentModel(
      id: data['id'],
      email: data['email'],
      type: data['type'],
      name: data['name'],
      studentNumber: data['studentNumber'],
      advisorRef: FirebaseFirestore.instance.doc(data['advisorRef']),
      scheduleRef: FirebaseFirestore.instance.doc(data['scheduleRef']),
      academicDegree: data['academicDegree'],
      generalSituation: data['generalSituation'],
      planHours: data['planHours'],
      studentStatus: data['studentStatus'],
      studyType: data['studyType'],
      college: data['college'],
      major: data['major'],
      gpa: (data['gpa'] as num).toDouble(),
      level: data['level'],
      semester: data['semester'],
      completedHours: data['completedHours'],
      registeredHours: data['registeredHours'],
      remainingHours: data['remainingHours'],
    );
  }
}
