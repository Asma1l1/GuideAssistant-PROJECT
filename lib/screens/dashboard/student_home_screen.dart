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

  @override
  void initState() {
    super.initState();
    _studentData = fetchStudentData();
  }

  Future<StudentModel?> fetchStudentData() async {
    try {
      // جلب بيانات الطالب باستخدام البريد الإلكتروني
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('تعذر العثور على بيانات الطالب.');
      }

      final studentDoc = querySnapshot.docs.first;
      return StudentModel.fromFirestore(
          studentDoc.data() as Map<String, dynamic>, studentDoc.id);
    } catch (e) {
      print('خطأ في جلب بيانات الطالب: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الصفحة الرئيسية للطالب'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/FirstPage');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/icons/stHome.png'), // صورة الخلفية
            fit: BoxFit.cover, // تغطية كامل الشاشة
          ),
        ),
        child: FutureBuilder<StudentModel?>(
          future: _studentData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text('تعذر تحميل بيانات الطالب.'));
            }

            final student = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 250.0, 16.0, 16.0), // إضافة مسافة من الأعلى,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مرحباً ${student.email}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'مرشدك الأكاديمي: ${student.advisorUsername}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
