import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // تسجيل الدخول
  Future<void> signIn(String email, String password, String type) async {
    try {
      // تسجيل الدخول باستخدام Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // التحقق من بيانات المستخدم في Firestore باستخدام البريد الإلكتروني
      QuerySnapshot userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception('المستخدم غير موجود في السجلات');
      }

      // التحقق من نوع المستخدم
      final userDoc = userQuery.docs.first;
      if (userDoc['type'] != type) {
        throw Exception('نوع المستخدم غير صحيح');
      }

      print('تم تسجيل الدخول بنجاح: ${userCredential.user!.email}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('المستخدم غير موجود');
      } else if (e.code == 'wrong-password') {
        throw Exception('كلمة المرور غير صحيحة');
      } else {
        throw Exception('فشل تسجيل الدخول: ${e.message}');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء تسجيل الدخول: $e');
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('تم تسجيل الخروج بنجاح');
    } catch (e) {
      throw Exception('حدث خطأ أثناء تسجيل الخروج: $e');
    }
  }
}




// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';

// class AuthProvider with ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // تعريف طريقة تسجيل الدخول
//   Future<void> signIn(String email, String password, String type) async {

//     try {
//       print('التسجيل: البريد الإلكتروني: $email، النوع: $type'); // عرض البيانات المدخلة

//       final querySnapshot = await _firestore
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .where('password', isEqualTo: password)
//           .where('type', isEqualTo: type)
//           .get();

//       if (querySnapshot.docs.isEmpty) {
//         throw Exception('المستخدم غير موجود أو النوع غير صحيح');
//       }

//       final userDoc = querySnapshot.docs.first.data();

//       if (userDoc['password'] != password) {
//         throw Exception('كلمة المرور غير صحيحة');
//       }
//     } catch (e) {
//       throw Exception('فشل تسجيل الدخول: $e');
//     }
//   }
// }