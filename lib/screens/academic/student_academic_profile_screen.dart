import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muieen_project/providers/advisor_provider.dart';
import 'package:muieen_project/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../models/student_model.dart';
import '../../providers/student_provider.dart';
import '../widgets/student_app_drawer.dart';
import '../widgets/customAppBar.dart';

class StudentAcademicProfilePage extends StatelessWidget {
  const StudentAcademicProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final studentProvider = Provider.of<StudentProvider>(context);
    final advisorProvider = Provider.of<AdvisorProvider>(context);
    final student = studentProvider.student;
    final advisor = advisorProvider.advisor;

    // Fetch student and advisor information when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
    });

    return Scaffold(
      backgroundColor: const Color(0xFFe1e5e6),
      endDrawer: const StudentAppDrawer(),
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: -5,
            left: -20,
            right: -5,
            child: Image.asset(
              'assets/icons/bgShape.png', // Replace with your image path
              fit: BoxFit.fill,
              height: 200, // Adjust the height as needed
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            left: 20,
            child: CustomAppBar(
              title: const Text(
                'الملف الأكاديمي',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 200),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          20,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.2), // Shadow color with opacity
                          blurRadius: 10, // Soften the shadow
                          spreadRadius: 2, // Extend the shadow
                          offset: const Offset(0, 5), // Shadow position (x, y)
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 360,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Main Info
                          Row(
                            children: [
                              const Icon(Icons.person_outline),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student?.name ?? '',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    student?.studentNumber.toString() ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "المعدل التراكمي: ${student?.gpa ?? ''}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Two-column layout
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Column 1
                              SizedBox(
                                height: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "الفصل: ${student?.semester}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "نوع الدراسة: ${student?.studyType}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      student?.major ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      student?.college ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "المستوى: ${student?.level ?? ''}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 100),
                              // Column 2
                              SizedBox(
                                height: 180,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Icon(
                                      Icons.date_range,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "الوضع العام: ${student?.generalSituation ?? ''}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      student?.academicDegree ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "ساعات الخطة: ${student?.planHours ?? 0}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      student?.studentStatus ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "ساعات",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "مجتازة ${student?.completedHours ?? ''}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "مسجلة ${student?.registeredHours ?? ''}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "متبقية ${student?.remainingHours ?? ''}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "المشرف الأكاديمي: ${advisor?.name}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
