import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:muieen_project/providers/auth_provider.dart' ; 

class LoginAdvisorPage extends StatefulWidget {
  @override
  _LoginAdvisorPageState createState() => _LoginAdvisorPageState();
}

class _LoginAdvisorPageState extends State<LoginAdvisorPage> {
  final TextEditingController _emailController = TextEditingController(); // حقل إدخال البريد الإلكتروني
  final TextEditingController _passwordController = TextEditingController(); // حقل إدخال كلمة المرور

  void _loginAdvisor() async {
  final email = _emailController.text.trim(); // قراءة البريد الإلكتروني
  final password = _passwordController.text.trim(); // قراءة كلمة المرور

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('يرجى إدخال البريد الإلكتروني وكلمة المرور')),
    );
    return;
  }

  try {
    // استدعاء الطريقة signIn
    await Provider.of<AuthProvider>(context, listen: false)
        .signIn(email, password, 'ADVISOR'); // تمرير النوع 'ADVISOR'

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
    );
    Navigator.pushNamed(context, '/advisorDashboard'); // الانتقال إلى لوحة التحكم
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('خطأ أثناء تسجيل الدخول: $e')), // عرض الخطأ
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل الدخول - مرشد'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'الإيميل الأكاديمي',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'كلمة السر',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loginAdvisor,
              child: Text('دخول'),
            ),
          ],
        ),
      ),
    );
  }
}

// class LoginAdvisorPage extends StatefulWidget {
//   final String backgroundImage = 'assets/icons/login.png'; // مسار الخلفية الخاص بواجهة تسجيل الطالب
//   @override
//   _LoginAdvisorPageState createState() => _LoginAdvisorPageState();
// }

// class _LoginAdvisorPageState extends State<LoginAdvisorPage> {
//   final TextEditingController _usernameController = TextEditingController(); // حقل إدخال اسم المستخدم
//   final TextEditingController _passwordController = TextEditingController(); // حقل إدخال كلمة المرور

//   void _loginAdvisor() async {
//     final username = _usernameController.text.trim(); // قراءة اسم المستخدم
//     final password = _passwordController.text.trim(); // قراءة كلمة المرور

//     if (username.isEmpty || password.isEmpty) {
//       // التحقق من الحقول الفارغة
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('يرجى إدخال اسم المستخدم وكلمة المرور')),
//       );
//       return;
//     }

//     try {
//       // البحث عن المستخدم في Firestore
//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('username', isEqualTo: username)
//           .where('role', isEqualTo: 'ADVISOR')
//           .get();

//       if (snapshot.docs.isEmpty) {
//         // إذا لم يتم العثور على المستخدم
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('اسم المستخدم غير موجود')),
//         );
//         return;
//       }

//       final userData = snapshot.docs.first.data();
//       if (userData['password'] != password) {
//         // إذا كانت كلمة المرور غير صحيحة
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('كلمة المرور غير صحيحة')),
//         );
//         return;
//       }

//       // تسجيل الدخول ناجح
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
//       );
//       Navigator.pushNamed(context, '/advisorDashboard'); // الانتقال إلى لوحة التحكم الخاصة بالمرشد
//     } catch (e) {
//       // عرض رسالة خطأ عند حدوث مشكلة
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ أثناء تسجيل الدخول: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('تسجيل الدخول - مرشد'),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(widget.backgroundImage), // تعيين الخلفية الخاصة بالكلاس
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(
//                 labelText: 'اسم المستخدم',
//                 prefixIcon: Icon(Icons.person),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(
//                 labelText: 'كلمة السر',
//                 prefixIcon: Icon(Icons.lock),
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: _loginAdvisor,
//               child: Text('دخول'),
//             ),
//           ],
//         ),
//       ),
//       )  
//     );
//   }
// }



