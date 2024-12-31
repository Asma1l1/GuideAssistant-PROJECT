import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // تعريف طريقة تسجيل الدخول
  Future<void> signIn(String email, String password, String type) async {

    try {
      print('التسجيل: البريد الإلكتروني: $email، النوع: $type'); // عرض البيانات المدخلة

      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .where('type', isEqualTo: type)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('المستخدم غير موجود أو النوع غير صحيح');
      }

      final userDoc = querySnapshot.docs.first.data();

      if (userDoc['password'] != password) {
        throw Exception('كلمة المرور غير صحيحة');
      }
    } catch (e) {
      throw Exception('فشل تسجيل الدخول: $e');
    }
  }
}