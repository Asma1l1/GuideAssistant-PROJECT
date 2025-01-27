import 'package:cloud_firestore/cloud_firestore.dart';
import 'request_model.dart';

class DeleteRequestModel extends RequestModel {
  final String reason; // سبب الحذف

  DeleteRequestModel({
    required super.reqType,
    required super.studentRef,
    required super.courseID,
    required super.requestID,
    required super.dateSubmitted,
    required super.status,
    required this.reason,
  });

  // تحويل كائن Dart إلى Firestore JSON
  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'reason': reason,
      });
  }

  // دالة لإنشاء كائن DeleteRequestModel من Firestore
  factory DeleteRequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DeleteRequestModel(
      reqType: data['reqType'] ?? 'DELETE_REQUEST',
      studentRef: data['studentID'] ?? FirebaseFirestore.instance.doc('/students/غير_متوفر'),
      courseID: data['courseID'] ?? FirebaseFirestore.instance.doc('/courses/غير_متوفر'),
      requestID: doc.id,
      dateSubmitted: (data['dateSubmitted'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: RequestStatus.values.firstWhere(
        (e) => e.toString().split('.').last == data['status'],
        orElse: () => RequestStatus.pending, // الحالة الافتراضية
      ),
      reason: data['reason'] ?? 'غير محدد',
    );
  }
}
