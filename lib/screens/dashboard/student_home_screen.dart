import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/student_model.dart';

class StudentHomePage extends StatefulWidget {
  final DocumentReference studentRef;

  const StudentHomePage({Key? key, required this.studentRef}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  late Future<StudentModel?> _studentData;
  late Future<String?> _advisorName;

  @override
  void initState() {
    super.initState();
    _studentData = fetchStudentData();
    _advisorName = fetchAdvisorName();
  }

  Future<StudentModel?> fetchStudentData() async {
    try {
      final studentSnapshot = await widget.studentRef.get();

      if (!studentSnapshot.exists) {
        return null;
      }

      final studentDoc = studentSnapshot.data() as Map<String, dynamic>;
      return StudentModel.fromFirestore(studentDoc, widget.studentRef.id);
    } catch (e) {
      print("Error fetching student data: $e");
      return null;
    }
  }

  Future<String?> fetchAdvisorName() async {
    try {
      final studentSnapshot = await widget.studentRef.get();

      if (!studentSnapshot.exists) {
        return null;
      }

      final studentData = studentSnapshot.data() as Map<String, dynamic>;
      if (!studentData.containsKey('advisorID')) {
        return null;
      }

      final advisorRef = studentData['advisorID'] as DocumentReference;
      final advisorSnapshot = await advisorRef.get();

      if (!advisorSnapshot.exists) {
        return null;
      }

      final advisorData = advisorSnapshot.data() as Map<String, dynamic>;
      final firstName = advisorData['firstName'] ?? 'غير معروف';
      final lastName = advisorData['lastName'] ?? 'غير معروف';

      return '$firstName $lastName';
    } catch (e) {
      print("Error fetching advisor name: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('الصفحة الرئيسية للطالب'),
          leading: IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () async {
              Navigator.pushNamed(
                context,
                '/StudentNotificationsScreen',
                arguments: widget.studentRef, // تمرير مرجع الطالب بشكل صحيح
              );
            },
          ),
        ),
        endDrawer: _buildDrawer(context),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/stHome.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: FutureBuilder<StudentModel?>(
            future: _studentData,
            builder: (context, studentSnapshot) {
              if (studentSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (studentSnapshot.hasError ||
                  studentSnapshot.data == null) {
                return Center(
                  child: Text(
                    'تعذر العثور على بيانات الطالب.\nتأكد من صحة البيانات.',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final student = studentSnapshot.data!;
              return FutureBuilder<String?>(
                future: _advisorName,
                builder: (context, advisorSnapshot) {
                  if (advisorSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final advisorName = advisorSnapshot.data ?? 'غير متوفر';
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 230),
                        Text(
                          'مرحباً ${student.name}',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'مرشدك الأكاديمي: $advisorName',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              _buildGridButton(
                                context,
                                'نموذج الحذف',
                                Icons.delete,
                                () {
                                  Navigator.pushNamed(
                                    context,
                                    '/delete_request_screen',
                                    arguments: widget.studentRef,
                                  );
                                },
                              ),
                              _buildGridButton(
                                  context, 'نموذج الإضافة', Icons.add, () {
                                Navigator.pushNamed(
                                  context,
                                  '/delete_request_screen',
                                  arguments: widget.studentRef,
                                );
                              }),
                              _buildGridButton(context, 'نموذج تغيير شعبة',
                                  Icons.edit, () {}),
                              _buildGridButton(
                                  context,
                                  'نموذج الطلبات الارتباطية',
                                  Icons.link,
                                  () {}),
                              _buildGridButton(
                                context,
                                'الجدول الدراسي',
                                Icons.schedule,
                                () async {
                                  final studentSnapshot =
                                      await widget.studentRef.get();
                                  if (studentSnapshot.exists) {
                                    final studentData = studentSnapshot.data()
                                        as Map<String, dynamic>;
                                    if (studentData
                                        .containsKey('scheduleRef')) {
                                      DocumentReference scheduleRef =
                                          studentData['scheduleRef'];
                                      Navigator.pushNamed(
                                        context,
                                        '/scheduleScreen',
                                        arguments: scheduleRef,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'تعذر العثور على جدول دراسي لهذا الطالب')),
                                      );
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('القائمة الجانبية',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: Icon(Icons.folder),
            title: Text('الملف الأكاديمي'),
            onTap: () {
              Navigator.pushNamed(context, '/academicProfile');
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('سجل الطلبات'),
            onTap: () {
              Navigator.pushNamed(context, '/requestLog');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/FirstPage');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(BuildContext context, String title, IconData icon,
      VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
        elevation: 4,
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          SizedBox(height: 8),
          Text(title,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
