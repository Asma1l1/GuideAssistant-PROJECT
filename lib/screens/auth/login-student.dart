import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginStudentPage extends StatefulWidget {
  static const String screenRoute = '/LoginStudentPage';
  const LoginStudentPage({Key? key}) : super(key: key);

  @override
  _LoginStudentPageState createState() => _LoginStudentPageState();
}

class _LoginStudentPageState extends State<LoginStudentPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showSpinner = false;

  void _loginStudent() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى إدخال البريد الإلكتروني وكلمة المرور')),
      );
      return;
    }

    setState(() {
      showSpinner = true;
    });

    try {
      // تسجيل الدخول
      await Provider.of<AuthProvider>(context, listen: false)
          .signIn(email, password, 'STUDENT');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
      );

      Navigator.pushReplacementNamed(
        context,
        '/StudentHomePage',
        arguments: email, // تمرير البريد الإلكتروني كمعرف للطالب
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء تسجيل الدخول: $e')),
      );
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل الدخول - طالب'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'الإيميل الأكاديمي',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'كلمة السر',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 32),
            showSpinner
                ? CircularProgressIndicator()
                : ElevatedButton(
                    child: Text('دخول'),
                    onPressed: _loginStudent,
                  ),
          ],
        ),
      ),
    );
  }
}




// //import 'screens/firstPage.dart';

// class LoginStudentPage extends StatefulWidget {
//   final String backgroundImage = 'assets/icons/login.png'; // مسار الخلفية الخاص بواجهة تسجيل الطالب
//   @override
//   _LoginStudentPageState createState() => _LoginStudentPageState();
// }

// class _LoginStudentPageState extends State<LoginStudentPage> {

//   final TextEditingController _emailController = TextEditingController(); // حقل إدخال البريد الإلكتروني
//   final TextEditingController _passwordController = TextEditingController(); // حقل إدخال كلمة المرور

//   void _loginStudent() async {
//     final email = _emailController.text.trim(); // قراءة البريد الإلكتروني
//     final password = _passwordController.text.trim(); // قراءة كلمة المرور

//     if (email.isEmpty || password.isEmpty) {
//       // التحقق من الحقول الفارغة
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('يرجى إدخال البريد الإلكتروني وكلمة المرور')),
//       );
//       return;
//     }

//     try {
//       // البحث عن المستخدم في Firestore
//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .where('role', isEqualTo: 'STUDENT')
//           .get();

//       if (snapshot.docs.isEmpty) {
//         // إذا لم يتم العثور على المستخدم
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('البريد الإلكتروني غير موجود')),
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
//       Navigator.pushNamed(context, '/studentDashboard'); // الانتقال إلى لوحة التحكم الخاصة بالطالب
//     } catch (e) {
//       // عرض رسالة خطأ عند حدوث مشكلة
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ أثناء تسجيل الدخول: $e')),
//       );
//     }
//   }

//   @override
//  Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('تسجيل الدخول - طالب'),
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
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'الإيميل الأكاديمي',
//                 prefixIcon: Icon(Icons.email),
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
//               onPressed: _loginStudent,
//               child: Text('دخول'),
//             ),
//           ],
//         ),
//       ),
//       ),
//     );
//   }
// }
