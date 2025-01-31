import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muieen_project/models/course_model.dart';
import 'package:muieen_project/providers/student_provider.dart';

class CoursesProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CourseModel> _courses = [];

  List<CourseModel> get courses => _courses;

  Future<Map<String, dynamic>> fetchCourseData(
      DocumentReference courseRef) async {
    try {
      final documentSnapshot = await courseRef.get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        print('📌 Referenced course document does not exist');
        return {};
      }
    } catch (e) {
      print('🔥 Error fetching referenced course data: ${e.toString()}');
      return {};
    }
  }

  Future<void> fetchCoursesForAdding(int level) async {
    try {
      final querySnapshot = await _firestore
          .collection('offeredCourses')
          .doc("2024-s1")
          .collection("courses")
          .where("level", isEqualTo: level + 1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        _courses = querySnapshot.docs.map((doc) {
          print(doc.data().toString());
          return CourseModel.fromFirestore(
            doc.data(),
            doc.id,
          );
        }).toList();

        notifyListeners();
      } else {
        _courses = [];
        print('📌 No courses found for level: $level');
        notifyListeners();
      }
    } catch (e) {
      print('🔥 Error fetching courses: ${e.toString()}');
    }
  }

  Future<void> fetchCoursesForDeletingAndEditing(int level) async {
    try {
      final querySnapshot = await _firestore
          .collection('offeredCourses')
          .doc("2024-s1")
          .collection("courses")
          .where("level", isEqualTo: level)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        _courses = querySnapshot.docs.map((doc) {
          return CourseModel.fromFirestore(
            doc.data(),
            doc.id,
          );
        }).toList();

        notifyListeners();
      } else {
        _courses = [];
        print('📌 No courses found for level: $level');
        notifyListeners();
      }
    } catch (e) {
      print('🔥 Error fetching courses: ${e.toString()}');
    }
  }
}
