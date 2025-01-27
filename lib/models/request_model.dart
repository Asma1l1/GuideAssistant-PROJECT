import 'package:cloud_firestore/cloud_firestore.dart';

// تعريف enum على مستوى أعلى
enum RequestStatus {
  pending,   // قيد الانتظار
  approved,  // تمت الموافقة
  rejected,  // مرفوض
  processing // قيد المعالجة
}

// الكلاس الأب العام لجميع أنواع الطلبات
class RequestModel {
  String reqType;   // نوع الطلب
  RequestStatus status;    // حالة الطلب باستخدام enum
  final DocumentReference studentRef; // معرف الطالب
  final DocumentReference courseID;  // معرف المقرر
  DateTime dateSubmitted; // تاريخ التقديم
  String requestID; // معرف الطلب

  RequestModel({
    required this.reqType,
    required this.status,
    required this.studentRef,
    required this.courseID,
    required this.dateSubmitted,
    required this.requestID,
  });

  // تحويل كائن Dart إلى JSON لتخزينه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'reqType': reqType,
      'status': status.toString().split('.').last, // تحويل enum إلى String
      'studentID': studentRef,
      'courseID': courseID,
      'dateSubmitted': Timestamp.fromDate(dateSubmitted),
      'requestID': requestID,
    };
  }

  // دالة لإنشاء كائن `RequestModel` من Firestore
  factory RequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RequestModel(
      reqType: data['reqType'] ?? 'UNKNOWN',
      status: RequestStatus.values.firstWhere(
        (e) => e.toString().split('.').last == data['status'],
        orElse: () => RequestStatus.pending, // قيمة افتراضية
      ),
      studentRef: data['studentID'] ?? FirebaseFirestore.instance.doc('/students/غير_متوفر'),
      courseID: data['courseID'] ?? FirebaseFirestore.instance.doc('/courses/غير_متوفر'),
      dateSubmitted: (data['dateSubmitted'] as Timestamp?)?.toDate() ?? DateTime.now(),
      requestID: doc.id,
    );
  }
}
