import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muieen_project/models/student_model.dart';

class StudentProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StudentModel? _student;

  StudentModel? get student => _student;

  // Fetch student information by studentId
  Future<void> fetchStudent(String studentId) async {
    final studentDoc =
        await _firestore.collection('users').doc(studentId).get();
    if (studentDoc.exists) {
      
      _student = StudentModel.fromFirestore(
        studentDoc.data()!,
        studentId,
      );
      print(_student?.name);
      notifyListeners();
    } else {
      print('student not found');
      notifyListeners();
    }
  }
}
