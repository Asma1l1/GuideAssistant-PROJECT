import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AcademicAdvisorApp());
}

class AcademicAdvisorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AdvisorHomePage(),
      ),
    );
  }
}

class AdvisorHomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationsPage()),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text('1', style: TextStyle(fontSize: 12, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: AdvisorDashboard(),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ListTile(
            trailing: Icon(Icons.close),
            onTap: () => Navigator.pop(context),
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("تسجيل الخروج", style: TextStyle(color: Colors.red)),
            onTap: () {
              // تنفيذ تسجيل الخروج
            },
          ),
        ],
      ),
    );
  }
}

class AdvisorDashboard extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('advisors').doc('advisor_id').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('لا توجد بيانات'));
        }
        var data = snapshot.data!.data() as Map<String, dynamic>;
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("أهلاً،", style: GoogleFonts.tajawal(fontSize: 22.sp, fontWeight: FontWeight.bold)),
              Text("د. ${data['name']}", style: GoogleFonts.tajawal(fontSize: 18.sp)),
              SizedBox(height: 10.h),
              Text("عدد الطلاب ${data['students_count']}", style: GoogleFonts.tajawal(fontSize: 16.sp)),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => StudentFilter(),
                ),
                child: Text("تصنيف الطلاب"),
              ),
              Expanded(child: StudentList()),
            ],
          ),
        );
      },
    );
  }
}

class StudentList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('students').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var students = snapshot.data!.docs;
        return ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            var student = students[index].data() as Map<String, dynamic>;
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.h),
              child: ListTile(
                title: Text("الاسم: ${student['name']}", style: GoogleFonts.tajawal(fontSize: 18.sp)),
                subtitle: Text("الرقم الجامعي: ${student['id']}\nالمستوى: ${student['level']}", style: GoogleFonts.tajawal()),
                trailing: Column(
                  children: [
                    Text("عدد الطلبات", style: GoogleFonts.tajawal(fontSize: 14.sp)),
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(student['requests'].toString(), style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class StudentFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("تصنيف", style: GoogleFonts.tajawal(fontSize: 22.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            children: ["4 - 3.5", "3.49 - 2.75", "2.74 - 1.75", "1.74 - 1.0"]
                .map((e) => FilterChip(label: Text(e), onSelected: (val) {}))
                .toList(),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            children: ["ممتاز", "متوقع تخرجه", "غير متخرج", "مفصول مؤقت"]
                .map((e) => FilterChip(label: Text(e), onSelected: (val) {}))
                .toList(),
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("تطبيق"),
          ),
        ],
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الإشعارات")),
      body: Center(child: Text("قائمة الإشعارات")),
    );
  }
}
