import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../records/student_requests_log_screen.dart';

class AddCoursePage extends StatefulWidget {
  static const String screenRoute = 'add_request_screen';
    final DocumentReference studentRef;

  const AddCoursePage({Key? key, required this.studentRef}) : super(key: key);
  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  String? selectedCourse;
  String? selectedSection;
  String? alternativeSection;

  final List<String> courses = [
    'المقرر 1',
    'المقرر 2',
    'المقرر 3'
  ]; // قائمة المقررات المخزنة
  final List<String> sections = [
    'الشعبة 1',
    'الشعبة 2',
    'الشعبة 3'
  ]; // قائمة الشعب

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('نموذج طلب إضافة مقرر')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1- ما المقرر الذي تود إضافته؟'),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(hintText: 'اختر المقرر'),
              value: selectedCourse,
              items: courses.map((course) {
                return DropdownMenuItem(
                  value: course,
                  child: Text(course),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourse = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text('2- اختر الشعبة المرادة'),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(hintText: 'اختر الشعبة'),
              value: selectedSection,
              items: sections.map((section) {
                return DropdownMenuItem(
                  value: section,
                  child: Text(section),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSection = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text('3- اختر شعبة بديلة'),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(hintText: 'اختر شعبة بديلة'),
              value: alternativeSection,
              items: sections.map((section) {
                return DropdownMenuItem(
                  value: section,
                  child: Text(section),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  alternativeSection = value;
                });
              },
            ),
            SizedBox(height: 30),
            // ElevatedButton(
            //   onPressed: () {
            //     if (selectedCourse != null && selectedSection != null) {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => StudentRequestsLogScreen(
            //             course: selectedCourse!,
            //             section: selectedSection!,
            //             alternative: alternativeSection,
            //           ),
            //         ),
            //       );
            //     }
            //   },
            //   child: Text('إتمام'),
            // ),
          ],
        ),
      ),
    );
  }
}
