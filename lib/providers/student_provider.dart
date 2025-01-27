// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/student_model.dart';

// class StudentProvider with ChangeNotifier {
//   StudentModel? _student;
//   bool _isLoading = false;
//   String? _errorMessage;

//   StudentModel? get student => _student;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   Future<void> fetchStudentData(String email) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('email', isEqualTo: email.toLowerCase().trim())
//           .get();

//       if (querySnapshot.docs.isEmpty) {
//         _errorMessage = 'لا توجد بيانات لهذا البريد الإلكتروني.';
//         _isLoading = false;
//         notifyListeners();
//         return;
//       }

//       final studentDoc = querySnapshot.docs.first;
//       _student = StudentModel.fromFirestore(
//           studentDoc.data() as Map<String, dynamic>, studentDoc.id);
//     } catch (e) {
//       _errorMessage = 'حدث خطأ أثناء جلب البيانات';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<String?> fetchAdvisorName() async {
//     if (_student == null) return null;
//     try {
//       final advisorSnapshot = await _student!.advisorRef.get();
//       if (!advisorSnapshot.exists) return 'غير متوفر';
//       final data = advisorSnapshot.data() as Map<String, dynamic>;
//       return '${data['firstName'] ?? 'غير معروف'} ${data['lastName'] ?? 'غير معروف'}';
//     } catch (e) {
//       return 'غير متوفر';
//     }
//   }
// }
