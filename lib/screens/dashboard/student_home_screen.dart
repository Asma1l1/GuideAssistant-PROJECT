import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/student_model.dart';

class StudentHomePage extends StatefulWidget {
  static const String screenRoute = '/StudentHomePage';
  final String email;

  const StudentHomePage({Key? key, required this.email}) : super(key: key);

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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email.toLowerCase().trim())
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final studentDoc = querySnapshot.docs.first;
      return StudentModel.fromFirestore(
          studentDoc.data() as Map<String, dynamic>, studentDoc.id);
    } catch (e) {
      return null;
    }
  }

  Future<String?> fetchAdvisorName() async {
    try {
      final studentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email.toLowerCase().trim())
          .get();

      if (studentSnapshot.docs.isEmpty) {
        return null;
      }

      final studentData = studentSnapshot.docs.first.data();
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
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // لضبط النصوص من اليمين إلى اليسار
      child: Scaffold(
        appBar: AppBar(
          title: Text('الصفحة الرئيسية للطالب'),
          leading: IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () async {
              final studentRef = await FirebaseFirestore.instance
                  .collection('users')
                  .where('email', isEqualTo: widget.email.toLowerCase().trim())
                  .get()
                  .then((snapshot) => snapshot.docs.first.reference);

              Navigator.pushNamed(
                context,
                '/StudentNotificationsScreen',
                arguments: studentRef,
              );
            },
          ),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ],
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
                    'تعذر العثور على بيانات الطالب.\nتأكد من صحة البريد الإلكتروني أو وجود البيانات في النظام.',
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
                        SizedBox(height: 230), // المسافة العلوية
                        Text(
                          'مرحباً ${student.name}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'مرشدك الأكاديمي: $advisorName',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 20),
                        // استخدام Expanded مع shrinkWrap لتجنب overflow
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            shrinkWrap:
                                true, // تحديد حجم GridView بناءً على المحتوى
                            physics:
                                NeverScrollableScrollPhysics(), // تعطيل التمرير داخل GridView
                            children: [
                              _buildGridButton(
                                context,
                                'نموذج الحذف',
                                Icons.delete,
                                '/deleteForm',
                              ),
                              _buildGridButton(
                                context,
                                'نموذج الإضافة',
                                Icons.add,
                                '/addForm',
                              ),
                              _buildGridButton(
                                context,
                                'نموذج تغيير شعبة',
                                Icons.edit,
                                '/changeSectionForm',
                              ),
                              _buildGridButton(
                                context,
                                'نموذج الطلبات الارتباطية',
                                Icons.link,
                                '/associativeForm',
                              ),
                              _buildGridButton(
                                context,
                                'الجدول الدراسي',
                                Icons.schedule,
                                '/schedulePage',
                              ),
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
            child: Text(
              'القائمة الجانبية',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
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
            title: Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/FirstPage');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(
      BuildContext context, String title, IconData icon, String route) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
        elevation: 4,
      ),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
