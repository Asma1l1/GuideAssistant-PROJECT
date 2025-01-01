import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'screens/main/firstPage.dart';
import 'screens/auth/login-student.dart';
import 'screens/auth/loginAdvisor.dart';
import 'screens/dashboard/student_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // تهيئة Firebase عند تشغيل التطبيق
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthProvider()), // تسجيل AuthProvider
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
          '/loginStudent': (context) => LoginStudentPage(), // صفحة تسجيل الطالب
          '/loginAdvisor': (context) => LoginAdvisorPage(), // صفحة تسجيل المرشد
          '/StudentHomePage': (context) {
            final email = ModalRoute.of(context)!.settings.arguments as String;
            return StudentHomePage(email: email); // صفحة الطالب الرئيسية
          },
        }
        );
  }
}



// // ملف Flutter كامل يحتوي على الشاشات الأساسية مع تكامل Firebase App Check فقط

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';

// import 'screens/firstPage.dart';
// import 'screens/login-student.dart';
// import 'screens/loginAdvisor.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await FirebaseAppCheck.instance.activate();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//        initialRoute: '/',
//       routes: {
//         '/': (context) => FirstPage(),
//         '/loginStudent': (context) => LoginStudentPage(),
//         '/loginAdvisor': (context) => LoginAdvisorPage(),
//       },
//       debugShowCheckedModeBanner: false,
//       title: 'معين',
//       theme: ThemeData(
//         primarySwatch: Colors.teal,
//       ),
//       //home: FirstPage(),
//     );
//   }
// }

