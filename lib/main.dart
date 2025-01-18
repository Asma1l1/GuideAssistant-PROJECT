import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/requests_provider.dart';
import 'providers/notifications_provider.dart'; // إضافة مقدم الخدمة للإشعارات
import 'screens/main/firstPage.dart';
import 'screens/auth/login-student.dart';
import 'screens/auth/loginAdvisor.dart';
import 'screens/dashboard/student_home_screen.dart';
import 'screens/notifications/student_notifications_screen.dart'; // شاشة الإشعارات

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // تهيئة Firebase عند تشغيل التطبيق
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()), // تسجيل AuthProvider
        ChangeNotifierProvider(create: (_) => RequestsProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()), // مقدم خدمة الإشعارات
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // إخفاء شريط تصحيح الأخطاء
      title: 'معين', // عنوان التطبيق
      theme: ThemeData(
        primarySwatch: Colors.teal, // لون التطبيق الأساسي
      ),
      initialRoute: '/', // تحديد الصفحة الأولية للتطبيق
      routes: {
        '/': (context) => FirstPage(), // الصفحة الرئيسية
       '/FirstPage': (context) => FirstPage(), // صفحة تسجيل الطالب
        '/loginStudent': (context) => LoginStudentPage(), // صفحة تسجيل الطالب
        '/loginAdvisor': (context) => LoginAdvisorPage(), // صفحة تسجيل المرشد
        '/StudentHomePage': (context) {
          final email = ModalRoute.of(context)!.settings.arguments as String;
          return StudentHomePage(email: email); // صفحة الطالب الرئيسية
        },
        '/StudentNotificationsScreen': (context) {
          final studentRef =
              ModalRoute.of(context)!.settings.arguments as DocumentReference;
          return StudentNotificationsScreen(studentRef: studentRef); // شاشة الإشعارات
        },
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';

// import 'providers/auth_provider.dart';
// import 'providers/requests_provider.dart';
// import 'screens/main/firstPage.dart';
// import 'screens/auth/login-student.dart';
// import 'screens/auth/loginAdvisor.dart';
// import 'screens/dashboard/student_home_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // تهيئة Firebase عند تشغيل التطبيق
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//             create: (_) => AuthProvider()), // تسجيل AuthProvider
//             ChangeNotifierProvider(create: (_) => RequestsProvider()),
//       ],
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false, // إخفاء شريط تصحيح الأخطاء
//         title: 'معين', // عنوان التطبيق
//         theme: ThemeData(
//           primarySwatch: Colors.teal, // لون التطبيق الأساسي
//         ),
//         initialRoute: '/', // تحديد الصفحة الأولية للتطبيق
//         routes: {
//           '/': (context) => FirstPage(), // الصفحة الرئيسية
//           '/loginStudent': (context) => LoginStudentPage(), // صفحة تسجيل الطالب
//           '/loginAdvisor': (context) => LoginAdvisorPage(), // صفحة تسجيل المرشد
//           '/StudentHomePage': (context) {
//             final email = ModalRoute.of(context)!.settings.arguments as String;
//             return StudentHomePage(email: email); // صفحة الطالب الرئيسية
//           },
//         }
//         );
//   }
// }



