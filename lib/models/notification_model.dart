// import 'package:cloud_firestore/cloud_firestore.dart';

// class NotificationModel {
//   final String id;
//   final DocumentReference? studentRef;
//   final DocumentReference? advisorRef;
//   final DocumentReference? requestRef;
//   final String status;
//   final String message;
//   final DateTime timestamp;
//   final bool isRead;

//   NotificationModel({
//     required this.id,
//     this.studentRef,
//     this.advisorRef,
//     this.requestRef,
//     required this.status,
//     required this.message,
//     required this.timestamp,
//     this.isRead = false,
//   });

//   factory NotificationModel.fromFirestore(
//       Map<String, dynamic> data, String id) {
//     return NotificationModel(
//       id: id,
//       studentRef: data['studentRef'] as DocumentReference,
//       advisorRef: data['advisorRef'] as DocumentReference,
//       requestRef: data['requestRef'] as DocumentReference,
//       status: data['status'] ?? '',
//       message: data['message'] ?? '',
//       timestamp: (data['timestamp'] as Timestamp).toDate(),
//       isRead: data['isRead'] ?? false, // معالجة القيمة الافتراضية
//     );
//   }

//   Map<String, dynamic> toFirestore() {
//     return {
//       'studentRef': studentRef,
//       'advisorRef': advisorRef,
//       'requestRef': requestRef,
//       'status': status,
//       'message': message,
//       'timestamp': Timestamp.fromDate(timestamp),
//       'isRead': isRead, // تخزين حالة الإشعار
//     };
//   }
// }
class NotificationModel {
  final String title;
  final String body;

  NotificationModel({required this.title, required this.body});
}
