import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muieen_project/models/course_model.dart';
import 'package:muieen_project/models/request_model.dart';
import 'package:muieen_project/providers/advisor_provider.dart';
import 'package:muieen_project/providers/auth_provider.dart';
import 'package:muieen_project/providers/courses_provider.dart';
import 'package:muieen_project/providers/request_group_provider.dart';
import 'package:muieen_project/providers/student_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/customAppBar.dart';

class AddCoursePage extends StatefulWidget {
  static const String screenRoute = 'add_request_screen';

  const AddCoursePage({super.key});

  @override
  AddCoursePageState createState() => AddCoursePageState();
}

class AddCoursePageState extends State<AddCoursePage> {
  CourseModel? selectedCourse;
  String? selectedSection;
  String? alternativeSection;
  final TextEditingController _reasonController = TextEditingController();

  List<CourseModel> _courses = [];
  List<String> _sections = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchCoursesFromFirestore();
  }

  void _fetchCoursesFromFirestore() async {
    final coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);

    if (authProvider.user == null) {
      print("🚨 Error: User is null. Ensure the user is logged in.");
      return;
    }

    print("✅ Fetching student data for UID: ${authProvider.user!.uid}");

    await studentProvider.fetchStudent(authProvider.user!.uid);

    if (studentProvider.student == null) {
      print("🚨 Error: Student data is null after fetch.");
      return;
    }

    int? studentLevel = studentProvider.student!.level;
    if (studentLevel == null) {
      print("🚨 Error: Student level is null.");
      return;
    }

    print("✅ Student Level: $studentLevel - Fetching courses...");

    await coursesProvider.fetchCoursesForAdding(studentLevel);

    if (coursesProvider.courses.isEmpty) {
      print("🚨 Error: No courses found for this level.");
    } else {
      print(
          "✅ Courses fetched successfully: ${coursesProvider.courses.length} courses found.");
    }

    setState(() {
      _courses = coursesProvider.courses;
    });
  }

  void _updateSections(String courseName) {
    final coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);
    final selectedCourseObj = coursesProvider.courses.firstWhere(
      (course) => course.courseCode == courseName,
    );

    setState(() {
      _sections = selectedCourseObj.sections
          .map((section) => section.name) // Extract section names
          .toList();
    });
  }

  Future<String> getCourseName(DocumentReference courseRef) async {
    final coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);
    final courseData = await coursesProvider.fetchCourseData(courseRef);
    return courseData['courseName'];
  }

  void _submitRequest() async {
    print('📌 Selected Course: $selectedCourse');
    print('📌 Selected Section: $selectedSection');
    print('📌 Alternative Section: $alternativeSection');
    print('📌 Reason: ${_reasonController.text}');

    // Use `listen: false` for all Provider.of calls in this method
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    final advisorProvider =
        Provider.of<AdvisorProvider>(context, listen: false);

    if (authProvider.user == null) {
      return;
    }

    if (authProvider.user != null) {
      await studentProvider.fetchStudent(authProvider.user!.uid);
      if (studentProvider.student != null) {
        await advisorProvider.fetchAdvisor(
          studentProvider.student!.advisorRef,
        );
      }
    }

    final requestGroupProvider = Provider.of<RequestGroupProvider>(
      context,
      listen: false,
    );

    requestGroupProvider.addRequest(
      request: AddRequestModel(
        courseRef: selectedCourse!,
        section: selectedSection!,
        alternativeSection: alternativeSection!,
        dateSubmitted: null,
      ),
      studentRef: studentProvider.student!,
      advisorRef: advisorProvider.advisor!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم تسجيل طلبك بنجاح يمكنك الذهاب الى صفحة طلباتي لارسال الطلب للمشرف',
        ),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFDDE2E6),
        body: SizedBox.expand(
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/icons/bgFooter.png',
                  fit: BoxFit.fill,
                  height: 250,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: CustomAppBar(
                  title: const Text(
                    'نموذج طلب إضافة مقرر',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100, left: 100, right: 100),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        '1- ما المقرر الذي تود إضافته ؟',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<CourseModel>(
                        value: selectedCourse,
                        hint: const Text('المقررات المطروحة',
                            style: TextStyle(color: Colors.grey)),
                        items: _courses.map((course) {
                          return DropdownMenuItem<CourseModel>(
                            value: course,
                            child: FutureBuilder<String>(
                              future: getCourseName(course.courseRef),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('Loading...');
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Text(
                                      snapshot.data ?? 'Unknown Course');
                                }
                              },
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCourse = value;
                            selectedSection = null;
                            alternativeSection = null;
                          });
                          _updateSections(value!.courseCode);
                        },
                        decoration: _inputDecoration(),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        '2- اختر الشعبة المرادة',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedSection,
                        hint: const Text('حدد الشعبة المرادة',
                            style: TextStyle(color: Colors.grey)),
                        items: _sections.map((section) {
                          return DropdownMenuItem<String>(
                            value: section,
                            child: Text(section),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSection = value;
                          });
                        },
                        decoration: _inputDecoration(),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        '3- اختر شعبة بديلة',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: alternativeSection,
                        hint: const Text('الشعبة البديلة',
                            style: TextStyle(color: Colors.grey)),
                        items: _sections.map((section) {
                          return DropdownMenuItem<String>(
                            value: section,
                            child: Text(section),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            alternativeSection = value;
                          });
                        },
                        decoration: _inputDecoration(),
                      ),
                      const SizedBox(height: 100),
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitRequest,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            'إتمام',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
