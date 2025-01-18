import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationsProvider with ChangeNotifier {
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

  Future<void> addNotification({
    required DocumentReference studentRef,
    required DocumentReference requestRef,
    required String status,
    required String message,
  }) async {
    try {
      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        studentRef: studentRef,
        requestRef: requestRef,
        status: status,
        message: message,
        timestamp: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notification.id)
          .set(notification.toFirestore());
      notifyListeners();
      print('تمت إضافة الإشعار بنجاح.');
    } catch (e) {
      print('خطأ أثناء إضافة الإشعار: $e');
    }
  }
}
