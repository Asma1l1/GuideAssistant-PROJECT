import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muieen_project/providers/advisor_provider.dart';
import 'package:muieen_project/providers/request_group_provider.dart';
import 'package:provider/provider.dart';
import 'package:muieen_project/providers/auth_provider.dart';

class LoginAdvisorPage extends StatefulWidget {
  const LoginAdvisorPage({super.key});

  @override
  LoginAdvisorPageState createState() => LoginAdvisorPageState();
}

class LoginAdvisorPageState extends State<LoginAdvisorPage> {
  final TextEditingController _emailController = TextEditingController(
    text: "balehyani@uqu.edu.sa",
  );
  final TextEditingController _passwordController = TextEditingController(
    text: "123456",
  );

  final RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@uqu\.edu\.sa$');

  bool showSpinner = false;

  void _loginAdvisor() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Show spinner
    setState(() {
      showSpinner = true;
    });

    try {
      // Sign in with email and password
      await Provider.of<AuthProvider>(context, listen: false)
          .signIn(email, password);

      // Fetch advisor data from Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final advisorRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
            
        await Provider.of<AdvisorProvider>(context, listen: false)
            .fetchAdvisor(advisorRef);
      }

      // Navigate to the advisor home page
      Navigator.pushReplacementNamed(
        context,
        '/AdvisorHomePage',
      );
    } catch (e) {
      print("Error during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ أثناء تسجيل الدخول: $e'),
        ),
      );
    } finally {
      // Hide spinner
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
              child: Column(
                children: [
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
                                padding:
                                    WidgetStateProperty.all<EdgeInsetsGeometry>(
                                  const EdgeInsets.symmetric(
                                    horizontal: 50,
                                    vertical: 20,
                                  ),
                                ),
                                backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color(0xFF1a3b47),
                                ),
                              ),
                              onPressed: _loginAdvisor,
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
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
