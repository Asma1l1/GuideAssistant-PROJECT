import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteRequestScreen extends StatefulWidget {
  static const String screenRoute = '/delete_request_screen';

  final DocumentReference studentRef;

  const DeleteRequestScreen({Key? key, required this.studentRef}) : super(key: key);

  @override
  _DeleteRequestScreenState createState() => _DeleteRequestScreenState();
}

class _DeleteRequestScreenState extends State<DeleteRequestScreen> {
  final TextEditingController _reasonController = TextEditingController();
  Map<String, dynamic>? _selectedCourse;
  List<Map<String, dynamic>> _courses = [];

  @override
  void initState() {
    super.initState();
    _fetchCoursesFromFirestore();
  }

  void _fetchCoursesFromFirestore() async {
    try {
      final studentSnapshot = await widget.studentRef.get();
      if (studentSnapshot.exists) {
        final studentData = studentSnapshot.data() as Map<String, dynamic>?;

        if (studentData != null && studentData.containsKey('scheduleRef')) {
          DocumentReference scheduleRef = studentData['scheduleRef'];
          final scheduleSnapshot = await scheduleRef.get();

          if (scheduleSnapshot.exists) {
            final scheduleData = scheduleSnapshot.data() as Map<String, dynamic>?;

            if (scheduleData != null && scheduleData.containsKey('courses')) {
              List<dynamic> courseEntries = scheduleData['courses'];
              List<Map<String, dynamic>> courseList = [];

              for (var course in courseEntries) {
                if (course is Map<String, dynamic> && course.containsKey('courseRef')) {
                  DocumentReference courseRef = course['courseRef'];
                  final courseSnapshot = await courseRef.get();

                  if (courseSnapshot.exists) {
                    final courseData = courseSnapshot.data() as Map<String, dynamic>?;

                    if (courseData != null && courseData.containsKey('courseRef')) {
                      DocumentReference planRef = courseData['courseRef'];
                      final planSnapshot = await planRef.get();

                      if (planSnapshot.exists) {
                        final planData = planSnapshot.data() as Map<String, dynamic>?;
                        final courseName = planData?['courseName'] ?? 'غير متوفر';

                        courseList.add({
                          'courseName': courseName,
                          'courseCode': planData?['courseCode'] ?? 'غير متوفر',
                          'courseRef': courseRef,
                          'hours': planData?['hours'] ?? 0,
                          'level': planData?['level'] ?? 0,
                        });
                      }
                    }
                  }
                }
              }

              setState(() {
                _courses = courseList;
              });
            }
          }
        }
      }
    } catch (e) {
      print('خطأ في تحميل المقررات: $e');
    }
  }

  void _submitRequest() async {
    if (_selectedCourse != null && _reasonController.text.isNotEmpty) {
      try {
        final studentSnapshot = await widget.studentRef.get();
        final studentData = studentSnapshot.data() as Map<String, dynamic>;
        int studentLevel = studentData['level'] ?? 0;
        int registeredHours = studentData['plan']['registeredHours'] ?? 0;
        int courseLevel = _selectedCourse!['level'];
        int courseHours = _selectedCourse!['hours'];

        if (studentLevel == courseLevel) {
          _showCustomDialog('تم رفض الطلب', 'لا يمكن حذف هذا المقرر، حيث أنه مقرر أساسي في مستواك الحالي.');
          return;
        }

        if ((registeredHours - courseHours) < 0) {
          _showCustomDialog('تم رفض الطلب', 'لا يمكن حذف المقرر، حيث أن ذلك سيؤثر على الحد الأدنى من الساعات المطلوبة.');
          return;
        }

        await widget.studentRef.update({
          'plan.registeredHours': registeredHours - courseHours,
        });

        await FirebaseFirestore.instance.collection('requests').add({
          'studentID': widget.studentRef,
          'courseID': _selectedCourse!['courseRef'],
          'courseName': _selectedCourse!['courseName'],
          'reason': _reasonController.text,
          'typeReq': 'DELETE',
          'status': 'قيد المراجعة',
          'dateSubmitted': FieldValue.serverTimestamp(),
        });

        _sendNotification('تم إرسال طلب الحذف للمقرر بنجاح');

        _showCustomDialog('نجاح', 'تم إرسال الطلب بنجاح.');
      } catch (e) {
        _showCustomDialog('خطأ', 'حدث خطأ أثناء إرسال الطلب: $e');
      }
    } else {
      _showCustomDialog('تنبيه', 'يرجى ملء جميع الحقول.');
    }
  }

  void _showCustomDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Text(
              message,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('حسنًا'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _sendNotification(String message) async {
    await FirebaseFirestore.instance.collection('Notifications').add({
      'studentID': widget.studentRef,
      'message': message,
      'status': 'جديد',
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, textAlign: TextAlign.right)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFDDE2E6),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'نموذج طلب حذف مقرر',
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/icons/notificationBackground.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text('1- ما المقرر الذي تود حذفه ؟', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<Map<String, dynamic>>(
                    value: _selectedCourse,
                    hint: const Text('حدد المادة المراد حذفها', style: TextStyle(color: Colors.grey)),
                    items: _courses.map((course) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: course,
                        child: Text('${course['courseName']} - ${course['courseCode']}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCourse = value;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('2- ادخل سبب الحذف', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _reasonController,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      hintText: 'سبب الحذف',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitRequest,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.black,
                      ),
                      child: const Text('إتمام', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
