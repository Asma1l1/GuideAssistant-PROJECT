import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class RequestsProvider with ChangeNotifier {
  Future<void> updateRequestStatus(
      DocumentReference requestRef, DocumentReference studentRef, String newStatus) async {
    try {
      // تحديث حالة الطلب في Firestore
      await requestRef.update({'status': newStatus});

      // إنشاء رسالة بناءً على الحالة الجديدة
      String message = '';
      if (newStatus == 'تم التنفيذ') {
        message = 'تم تغيير حالة الطلب إلى منفذ.';
      } else if (newStatus == 'مرفوض') {
        message = 'تم تغيير حالة الطلب إلى مرفوض.';
      }

      if (message.isNotEmpty) {
        // إنشاء الإشعار
        final notification = NotificationModel(
          id: '',
          studentRef: studentRef,
          requestRef: requestRef,
          status: newStatus,
          message: message,
          timestamp: DateTime.now(),
        );

        // إضافة الإشعار إلى Firestore
        await FirebaseFirestore.instance.collection('notifications').add(notification.toFirestore());
        print('تمت إضافة الإشعار بنجاح.');
      }

      notifyListeners(); // إشعار المستمعين بالتحديثات
    } catch (e) {
      print('خطأ أثناء تحديث حالة الطلب أو إضافة الإشعار: $e');
    }
  }

  Future<List<NotificationModel>> fetchNotifications(DocumentReference studentRef) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('studentRef', isEqualTo: studentRef)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return NotificationModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('خطأ أثناء جلب الإشعارات: $e');
      return [];
    }
  }
}
