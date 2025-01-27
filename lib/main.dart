import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/schedule/student_schedule_screen.dart';

import 'providers/auth_provider.dart';
import 'providers/requests_provider.dart';
import 'providers/notifications_provider.dart';

import 'providers/schedule_provider.dart';
import 'providers/student_provider.dart';
import 'screens/main/firstPage.dart';
import 'screens/auth/login-student.dart';
import 'screens/auth/loginAdvisor.dart';
import 'screens/dashboard/student_home_screen.dart';
import 'screens/notifications/student_notifications_screen.dart';
import 'screens/requests/associative_request_screen.dart';
import 'screens/requests/delete_request_screen.dart';
import 'screens/requests/request_form_screen.dart';
import 'screens/schedule/student_schedule_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RequestsProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(
            create: (_) => ScheduleProvider()), // إضافة بروفايدر الجدول
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'معين',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => FirstPage(),
        '/FirstPage': (context) => FirstPage(),
        '/loginStudent': (context) => LoginStudentPage(),
        '/loginAdvisor': (context) => LoginAdvisorPage(),
        '/StudentHomePage': (context) {
          final studentRef =
              ModalRoute.of(context)!.settings.arguments as DocumentReference;
          return StudentHomePage(studentRef: studentRef);
        },
        '/StudentNotificationsScreen': (context) {
          final studentRef =
              ModalRoute.of(context)!.settings.arguments as DocumentReference;
          return StudentNotificationsScreen(studentRef: studentRef);
        },
        
        '/delete_request_screen': (context) {
          final studentRef =
              ModalRoute.of(context)!.settings.arguments as DocumentReference;
          return DeleteRequestScreen(studentRef: studentRef);
        },
        '/associativeRequestScreen': (context) {
          final studentRef =
              ModalRoute.of(context)!.settings.arguments as DocumentReference;
          return AssociativeRequestScreen(studentRef: studentRef);
        },
        '/scheduleScreen': (context) {
          final studentRef =
              ModalRoute.of(context)!.settings.arguments as DocumentReference;
          return ScheduleScreen(studentRef: studentRef);
        },
        '/requestForm': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return RequestFormScreen(
              type: args['type'], studentRef: args['studentRef']);
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
// import 'providers/notifications_provider.dart';

// import 'screens/main/firstPage.dart';
// import 'screens/auth/login-student.dart';
// import 'screens/auth/loginAdvisor.dart';
// import 'screens/dashboard/student_home_screen.dart';
// import 'screens/notifications/student_notifications_screen.dart';
// import 'screens/requests/associative_request_screen.dart';
// import 'screens/requests/delete_request_screen.dart';
// import 'screens/requests/request_form_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); 

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()), 
//         ChangeNotifierProvider(create: (_) => RequestsProvider()),
//         ChangeNotifierProvider(create: (_) => NotificationsProvider()),
//       ],
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false, 
//       title: 'معين', 
//       theme: ThemeData(
//         primarySwatch: Colors.teal, 
//       ),
//       initialRoute: '/', 
//       routes: {
//         '/': (context) => FirstPage(), 
//         '/FirstPage': (context) => FirstPage(),
//         '/loginStudent': (context) => LoginStudentPage(), 
//         '/loginAdvisor': (context) => LoginAdvisorPage(), 
//         '/StudentHomePage': (context) {
//           final email = ModalRoute.of(context)!.settings.arguments as String;
//           return StudentHomePage(email: email); 
//         },
//         '/StudentNotificationsScreen': (context) {
//           final studentRef =
//               ModalRoute.of(context)!.settings.arguments as DocumentReference;
//           return StudentNotificationsScreen(studentRef: studentRef);
//         },
//         '/delete_request_screen': (context) {
//           final studentRef =
//               ModalRoute.of(context)!.settings.arguments as DocumentReference;
//           return DeleteRequestScreen(studentRef: studentRef);
//         },
//         '/associativeRequestScreen': (context) {
//           final studentRef =
//               ModalRoute.of(context)!.settings.arguments as DocumentReference;
//           return AssociativeRequestScreen(studentRef: studentRef);
//         },
//         '/requestForm': (context) {
//           final args = ModalRoute.of(context)!.settings.arguments
//               as Map<String, dynamic>;
//           return RequestFormScreen(
//               type: args['type'], studentRef: args['studentRef']);
//         },
//       },
//     );
//   }
// }
