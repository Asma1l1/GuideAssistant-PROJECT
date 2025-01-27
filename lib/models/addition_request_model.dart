import 'package:cloud_firestore/cloud_firestore.dart';
import 'request_model.dart';

class AddRequestModel extends RequestModel {
  final int section; // رقم الشعبة الحالي
  final int altSection; // رقم الشعبة البديلة

  AddRequestModel({
    required super.reqType,
    required super.studentRef,
    required super.courseID,
    required super.requestID,
    required super.dateSubmitted,
    required super.status,
    required this.section,
    required this.altSection,
  });

  // دالة لتحويل كائن Dart إلى Firestore JSON
  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'section': section,
        'alt_section': altSection,
      });
  }

  // دالة لإنشاء كائن AddRequestModel من Firestore
  factory AddRequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddRequestModel(
      reqType: data['reqType'] ?? 'ADD_REQUEST',
      studentRef: data['studentID'] ?? FirebaseFirestore.instance.doc('/students/غير_متوفر'),
      courseID: data['courseID'] ?? FirebaseFirestore.instance.doc('/courses/غير_متوفر'),
      requestID: doc.id,
      dateSubmitted: (data['dateSubmitted'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: RequestStatus.values.firstWhere(
        (e) => e.toString().split('.').last == data['status'],
        orElse: () => RequestStatus.pending, // الحالة الافتراضية
      ),
      section: data['section'] ?? 0,
      altSection: data['alt_section'] ?? 0,
    );
  }
}
