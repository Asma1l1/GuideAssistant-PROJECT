import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/student_model.dart';
import '../../screens/main/firstPage.dart';

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
      print('البريد الإلكتروني المستخدم: ${widget.email}');
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email.toLowerCase().trim())
          .get();

      print('عدد المستندات التي تم العثور عليها: ${querySnapshot.docs.length}');
      if (querySnapshot.docs.isEmpty) {
        print('لا توجد بيانات مطابقة للبريد الإلكتروني: ${widget.email}');
        return null;
      }

      final studentDoc = querySnapshot.docs.first;
      print('تم العثور على بيانات الطالب: ${studentDoc.data()}');
      return StudentModel.fromFirestore(
          studentDoc.data() as Map<String, dynamic>, studentDoc.id);
    } catch (e) {
      print('خطأ أثناء جلب بيانات الطالب: $e');
      return null;
    }
  }

  Future<String?> fetchAdvisorName() async {
    try {
      // جلب بيانات الطالب أولاً للحصول على advisorID كـ Reference
      final studentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email.toLowerCase().trim())
          .get();

      if (studentSnapshot.docs.isEmpty) {
        print('لا توجد بيانات مطابقة للبريد الإلكتروني: ${widget.email}');
        return null;
      }

      final studentData = studentSnapshot.docs.first.data();
      if (!studentData.containsKey('advisorID')) {
        print('الحقل advisorID غير موجود في بيانات الطالب.');
        return null;
      }

      final advisorRef = studentData['advisorID'] as DocumentReference;

      print('تم العثور على advisorID: $advisorRef');

      // جلب بيانات المرشد باستخدام DocumentReference
      final advisorSnapshot = await advisorRef.get();

      if (!advisorSnapshot.exists) {
        print('تعذر العثور على بيانات المرشد.');
        return null;
      }

      final advisorData = advisorSnapshot.data() as Map<String, dynamic>;
      print('تم العثور على بيانات المرشد: $advisorData');

      final firstName = advisorData['first_name'] ?? 'غير معروف';
      final lastName = advisorData['last_name'] ?? 'غير معروف';

      return '$firstName $lastName';
    } catch (e) {
      print('خطأ أثناء جلب بيانات المرشد: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الصفحة الرئيسية للطالب'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacementNamed(context, '/FirstPage');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black),
                    SizedBox(width: 8),
                    Text('تسجيل الخروج'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
            } else if (studentSnapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'خطأ أثناء تحميل بيانات الطالب.\nالرجاء المحاولة مرة أخرى.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _studentData = fetchStudentData();
                        });
                      },
                      child: Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            } else if (!studentSnapshot.hasData ||
                studentSnapshot.data == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'تعذر العثور على بيانات الطالب.\nتأكد من صحة البريد الإلكتروني أو وجود البيانات في النظام.',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _studentData = fetchStudentData();
                        });
                      },
                      child: Text('إعادة المحاولة'),
                    ),
                  ],
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
                } else if (advisorSnapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'خطأ أثناء تحميل بيانات المرشد.',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _advisorName = fetchAdvisorName();
                            });
                          },
                          child: Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                final advisorName = advisorSnapshot.data ?? 'غير متوفر';

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Expanded(
                        child: GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          children: [
                            _buildMenuButton(
                              context,
                              'نموذج الحذف',
                              Icons.delete,
                              '/deleteForm',
                            ),
                            _buildMenuButton(
                              context,
                              'نموذج الإضافة',
                              Icons.add,
                              '/addForm',
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
    );
  }

  Widget _buildMenuButton(
      BuildContext context, String title, IconData icon, String route) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
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
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
