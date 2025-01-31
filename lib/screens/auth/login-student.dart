import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muieen_project/providers/student_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginStudentPage extends StatefulWidget {
  static const String screenRoute = '/LoginStudentPage';
  const LoginStudentPage({Key? key}) : super(key: key);

  @override
  _LoginStudentPageState createState() => _LoginStudentPageState();
}

class _LoginStudentPageState extends State<LoginStudentPage> {
  final TextEditingController _emailController = TextEditingController(
    text: "s443010264@uqu.edu.sa",
  );
  final TextEditingController _passwordController = TextEditingController(
    text: "s122333",
  );
  bool showSpinner = false;

  final RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@uqu\.edu\.sa$');

  void _loginStudent() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('يرجى إدخال البريد الإلكتروني وكلمة المرور')),
      );
      return;
    }

    if (!emailRegExp.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('يرجى إدخال بريد إلكتروني بصيغة @uqu.edu.sa')),
      );
      return;
    }

    setState(() {
      showSpinner = true;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .signIn(email, password);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
      );

      final studentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email.toLowerCase().trim())
          .get();

      print(studentSnapshot.docs.first.data().toString());

      if (studentSnapshot.docs.isNotEmpty) {
        final studentRef = studentSnapshot.docs.first.reference;
        await Provider.of<StudentProvider>(context, listen: false)
            .fetchStudent(studentRef.id);

        Navigator.pushReplacementNamed(
          context,
          '/StudentHomePage',
          arguments: studentRef,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('البريد الإلكتروني غير موجود')),
        );
      }
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
      backgroundColor: const Color(0xFF1a3b47),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
          const Text(
            'تسجيل الدخول',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 100),
          Expanded(
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 120, horizontal: 80),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  child: Column(children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1a3b47),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFE6E3E3),
                                    width: 1,
                                  ),
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    labelText: 'الإيميل الأكاديمي',
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    prefixIcon: Icon(Icons.email),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        SizedBox(
                          height: 60,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1a3b47),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFE6E3E3),
                                    width: 1,
                                  ),
                                ),
                                child: TextField(
                                  obscureText: true,
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    labelText: 'كلمة السر',
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    prefixIcon: Icon(Icons.lock),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        showSpinner
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                      horizontal: 50,
                                      vertical: 20,
                                    ),
                                  ),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                    const Color(0xFF1a3b47),
                                  ),
                                ),
                                onPressed: _loginStudent,
                                child: const Text(
                                  'دخول',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ])))
        ],
      ),
    );
  }
}
