import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:muieen_project/models/request_model.dart';
import 'package:muieen_project/models/student_model.dart';
import 'package:muieen_project/providers/advisor_provider.dart';
import 'package:muieen_project/providers/courses_provider.dart';
import 'package:muieen_project/providers/notification_provider.dart';
import 'package:muieen_project/providers/request_group_provider.dart';
import 'package:muieen_project/screens/academic/academic_profile_screen.dart';
import 'package:muieen_project/screens/academic/student_academic_profile_screen.dart';
import 'package:muieen_project/screens/dashboard/advisor_home_screen.dart';
import 'package:muieen_project/screens/records/advisor_requests_by_student_screen.dart';
import 'package:muieen_project/screens/records/student_requests_log_details_page.dart';
import 'package:muieen_project/screens/records/student_requests_log_screen.dart';
import 'package:muieen_project/screens/requests/add_request_screen.dart';
import 'package:muieen_project/screens/requests/studet_requests_screen.dart';
import 'package:muieen_project/screens/requests/change_section_request_screen.dart';
import 'package:provider/provider.dart';
import 'screens/playground.dart';
import 'screens/schedule/student_schedule_screen.dart';

import 'providers/auth_provider.dart';
import 'providers/requests_provider.dart';

import 'providers/schedule_provider.dart';
import 'providers/student_provider.dart';
import 'screens/main/firstPage.dart';
import 'screens/auth/login-student.dart';
import 'screens/auth/loginAdvisor.dart';
import 'screens/dashboard/student_home_screen.dart';
import 'screens/notifications/student_notifications_screen.dart';
import 'screens/requests/delete_request_screen.dart';
import 'services/notifications_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: const FirebaseOptions(
      //   apiKey: "AIzaSyCg92iHmGrGAcN5uHkCCitnaADsv2oz0ww",
      //   appId: "1:552574779763:web:b5085d52fbcd24f98b8506",
      //   messagingSenderId: "552574779763",
      //   projectId: "muieen",
      //   authDomain: "muieen.firebaseapp.com",
      //   androidClientId: "1:552574779763:android:f3dda583580bb8258b8506",
      // ),
      );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RequestGroupProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => AdvisorProvider()),
        ChangeNotifierProvider(create: (_) => CoursesProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseMessagingService().initialize(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'معين',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const FirstPage(),
        '/FirstPage': (context) => const FirstPage(),
        '/loginStudent': (context) => const LoginStudentPage(),
        '/loginAdvisor': (context) => const LoginAdvisorPage(),
        '/StudentHomePage': (context) => const StudentHomePage(),
        '/AdvisorHomePage': (context) => const AdvisorHomePage(),
        '/StudentNotificationsScreen': (context) =>
            const StudentNotificationsScreen(),
        '/delete_request_screen': (context) => const DeleteRequestScreen(),
        '/add_request_screen': (context) => const AddCoursePage(),
        '/change_section_screen': (context) => const ChangeSectionPage(),
        '/profile': (context) => const StudentAcademicProfilePage(),
        '/Student_requests_log_screen': (context) =>
            const StudentRequestsLogPage(),
        '/Student_requests_screen': (context) => const StudentRequestsPage(),
        // '/associativeRequestScreen': (context) =>
        //     const AssociativeRequestScreen(),
        // '/scheduleScreen': (context) => const ScheduleScreen(),
        // '/requestForm': (context) {
        //   final args = ModalRoute.of(context)!.settings.arguments
        //       as Map<String, dynamic>;
        //   return RequestFormScreen(type: args['type']);
        // },
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/StudentAcademicProfilePage') {
          final student = settings.arguments as StudentModel;
          return MaterialPageRoute(
            builder: (context) => AcademicProfilePage(student: student),
          );
        }
        if (settings.name == '/AdvisorRequestsLogPage') {
          final group = settings.arguments as RequestGroupModel;
          return MaterialPageRoute(
            builder: (context) => AdvisorRequestsLogPage(
              group: group,
            ),
          );
        }
        if (settings.name == '/studentsRequestsLogPage') {
          final group = settings.arguments as RequestGroupModel;
          return MaterialPageRoute(
            builder: (context) => StudentRequestsLogDetailsPage(
              group: group,
            ),
          );
        }
      },
    );
  }
}
