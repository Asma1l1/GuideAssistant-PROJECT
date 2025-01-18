import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final DocumentReference studentRef;
  final DocumentReference requestRef;
  final String status;
  final String message;
  final DateTime timestamp;

  NotificationModel({
    required this.id,
    required this.studentRef,
    required this.requestRef,
    required this.status,
    required this.message,
    required this.timestamp,
  });

  factory NotificationModel.fromFirestore(Map<String, dynamic> data, String id) {
    return NotificationModel(
      id: id,
      studentRef: data['studentRef'] as DocumentReference,
      requestRef: data['requestRef'] as DocumentReference,
      status: data['status'] ?? '',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentRef': studentRef,
      'requestRef': requestRef,
      'status': status,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
