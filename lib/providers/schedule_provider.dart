import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/schedule_model.dart';

class ScheduleProvider with ChangeNotifier {
  List<ScheduleModel> _scheduleList = [];

  List<ScheduleModel> get scheduleList => _scheduleList;

  // جلب الجدول الدراسي للطالب باستخدام مرجع الطالب
  Future<void> fetchSchedule(DocumentReference studentRef) async {
    try {
      print("Fetching schedule for student: ${studentRef.path}");
      final studentSnapshot = await studentRef.get();
      
      if (studentSnapshot.exists) {
        List<dynamic> coursesData = studentSnapshot['courses'] ?? [];
        print("Fetched courses list: $coursesData");

        List<ScheduleModel> tempScheduleList = [];

        for (var courseData in coursesData) {
          print("Processing course: $courseData");

          DocumentReference courseRef = FirebaseFirestore.instance.doc(courseData['courseRef']);
          final courseDoc = await courseRef.get();

          if (!courseDoc.exists) {
            print("Course document not found: ${courseRef.path}");
            continue;
          }

          final courseDetails = courseDoc.data() as Map<String, dynamic>?;

          if (courseDetails == null || !courseDetails.containsKey('sections')) {
            print("Course details are missing or incorrect.");
            continue;
          }

          final sections = courseDetails['sections'] as Map<String, dynamic>? ?? {};
          print("Available sections: $sections");

          String sectionKey = sections.keys.firstWhere(
            (key) => sections[key]['section'].toString() == courseData['section'].toString(),
            orElse: () => '',
          );

          if (sectionKey.isEmpty) {
            print("No matching section found for: ${courseData['section']}");
            continue;
          }

          final selectedSection = sections[sectionKey];
          print("Selected section details: $selectedSection");

          tempScheduleList.add(ScheduleModel(
            courseRef: courseRef,
            section: selectedSection['section'] ?? 0,
            instructor: selectedSection['instructor'] ?? 'غير متوفر',
            location: selectedSection['location'] ?? 'غير متوفر',
            capacity: selectedSection['capecity'] ?? 0,
            enrolledStudents: selectedSection['enrolledStudent'] ?? 0,
            day: selectedSection['schedule']?['day'] ?? 'غير متوفر',
            time: selectedSection['schedule']?['time'] ?? 'غير متوفر',
            type: selectedSection['type'] ?? 'غير متوفر', 
            courseName:selectedSection['courseName'] ?? 'غير متوفر', 
            courseCode:selectedSection['courseCode'] ?? 'غير متوفر',
            creditHours: selectedSection['creditHours'] ?? 0,
          ));
        }

        _scheduleList = tempScheduleList;
      } else {
        print("Student document does not exist.");
        _scheduleList = [];
      }
      notifyListeners();
    } catch (e, stackTrace) {
      print('حدث خطأ أثناء جلب الجدول الدراسي: $e');
      print(stackTrace);
    }
  }

  // إضافة مادة إلى الجدول الدراسي للطالب
  Future<void> addCourseToSchedule(DocumentReference studentRef, ScheduleModel course) async {
    try {
      await studentRef.update({
        'courses': FieldValue.arrayUnion([course.toMap()])
      });
      _scheduleList.add(course);
      notifyListeners();
      print("Course added successfully.");
    } catch (e) {
      print('خطأ أثناء إضافة المادة: $e');
    }
  }

  // حذف مادة من الجدول الدراسي للطالب
  Future<void> removeCourseFromSchedule(DocumentReference studentRef, ScheduleModel course) async {
    try {
      await studentRef.update({
        'courses': FieldValue.arrayRemove([course.toMap()])
      });
      _scheduleList.removeWhere((c) => c.courseRef == course.courseRef);
      notifyListeners();
      print("Course removed successfully.");
    } catch (e) {
      print('خطأ أثناء حذف المادة: $e');
    }
  }
}
