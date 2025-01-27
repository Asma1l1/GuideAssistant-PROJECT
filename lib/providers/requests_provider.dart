import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/addition_request_model.dart';
import '../models/request_model.dart';
import '../models/notification_model.dart';

class RequestsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> associativeRequests = [];

  // 1. إضافة طلب ارتباطي جديد
  void addAssociativeRequest(String type, String details) {
    associativeRequests.add({'type': type, 'details': details});
    notifyListeners();
  }

  // 2. حذف طلب ارتباطي
  void removeAssociativeRequest(int index) {
    associativeRequests.removeAt(index);
    notifyListeners();
  }

  // 3. إعادة ترتيب الطلبات
  void reorderAssociativeRequests(int oldIndex, int newIndex) {
    final item = associativeRequests.removeAt(oldIndex);
    associativeRequests.insert(newIndex, item);
    notifyListeners();
  }

  // 4. التحقق من الترتيب الصحيح (محاكاة منطق العمل)
  bool isValidAssociativeOrder() {
    return associativeRequests.length > 1; 
  }

  // 5. إنشاء طلب ارتباطي
  void createAssociativeRequest(DocumentReference studentRef, String type) {
    associativeRequests.add({
      'studentRef': studentRef.path, 
      'type': type, 
      'details': ''
    });
    notifyListeners();
  }

  // 6. إرسال الطلب الارتباطي إلى Firestore
  Future<void> submitAssociativeRequest(DocumentReference studentRef) async {
    try {
      if (associativeRequests.length < 2) {
        throw Exception('يجب أن تحتوي الطلبات على طلبين على الأقل');
      }

      await _firestore.collection('associative_requests').add({
        'studentRef': studentRef,
        'requests': associativeRequests,
        'status': 'قيد المراجعة',
        'timestamp': Timestamp.now(),
      });

      associativeRequests.clear();
      notifyListeners();
    } catch (e) {
      throw Exception('حدث خطأ أثناء إرسال الطلبات: $e');
    }
  }

  // 7. إرسال إشعار للطالب عند اكتمال الطلب
  Future<void> notifyStudent(
      DocumentReference studentRef, DocumentReference requestRef, String message) async {
    try {
      final notification = NotificationModel(
        id: '',
        studentRef: studentRef,
        requestRef: requestRef,
        status: 'قيد المراجعة',
        message: message,
        timestamp: DateTime.now(),
      );

      await _firestore.collection('notifications').add(notification.toFirestore());
    } catch (e) {
      print('خطأ أثناء إرسال الإشعار: $e');
    }
  }

  // 8. جلب جميع الطلبات الخاصة بالطالب
  Future<List<AddRequestModel>> fetchStudentRequests(String studentId) async {
    try {
      final snapshot = await _firestore
          .collection('requests')
          .where('studentID', isEqualTo: _firestore.doc('users/$studentId'))
          .get();

      return snapshot.docs.map((doc) => AddRequestModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('حدث خطأ أثناء جلب الطلبات: $e');
    }
  }

  // 9. إرسال طلب حذف مقرر
  Future<void> submitDeleteRequest({
    required DocumentReference studentRef,
    required DocumentReference courseRef,
    required String reason,
  }) async {
    try {
      final requestData = {
        'studentID': studentRef,
        'courseID': courseRef,
        'reason': reason,
        'typeReq': 'DELETE',
        'status': 'قيد المراجعة',
        'dateSubmitted': Timestamp.now(),
      };

      await _firestore.collection('requests').add(requestData);
      notifyListeners();
      print('تم إرسال طلب الحذف بنجاح');
    } catch (e) {
      throw Exception('حدث خطأ أثناء إرسال طلب الحذف: $e');
    }
  }

  // 10. حذف طلب الحذف بناءً على ID الطلب
  Future<void> deleteRequest(String requestID) async {
    try {
      await _firestore.collection('requests').doc(requestID).delete();
      notifyListeners();
      print('تم حذف الطلب بنجاح');
    } catch (e) {
      throw Exception('خطأ أثناء حذف الطلب: $e');
    }
  }

  // 11. جلب طلبات الحذف للطالب
  Future<List<RequestModel>> fetchDeleteRequests(DocumentReference studentRef) async {
    try {
      final snapshot = await _firestore
          .collection('requests')
          .where('studentID', isEqualTo: studentRef)
          .where('typeReq', isEqualTo: 'DELETE')
          .get();

      return snapshot.docs.map((doc) => RequestModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('حدث خطأ أثناء جلب طلبات الحذف: $e');
    }
  }
}
