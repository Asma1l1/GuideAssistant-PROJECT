import 'package:cloud_firestore/cloud_firestore.dart';
import 'request_model.dart';

class AssociativeRequest extends RequestModel {
  final List<Map<String, dynamic>> requests;

  AssociativeRequest({
    required super.reqType,
    required super.studentRef,
    required super.courseID,
    required super.requestID,
    required super.dateSubmitted,
    required super.status,
    required this.requests,
  });

  // تحويل كائن Dart إلى Firestore JSON
  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'requests': requests.map((req) => {
              'type': req['type'] ?? 'UNKNOWN',
              'details': req['details'] ?? {},
              'priority': req['priority'] ?? 0,
            }).toList(),
      });
  }

  // دالة لإنشاء كائن AssociativeRequest من Firestore
  factory AssociativeRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AssociativeRequest(
      reqType: data['reqType'] ?? 'ASSOCIATIVE_REQUEST',
      studentRef: data['studentID'] ?? FirebaseFirestore.instance.doc('/students/غير_متوفر'),
      courseID: data['courseID'] ?? FirebaseFirestore.instance.doc('/courses/غير_متوفر'),
      requestID: doc.id,
      dateSubmitted: (data['dateSubmitted'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: RequestStatus.values.firstWhere(
        (e) => e.toString().split('.').last == data['status'],
        orElse: () => RequestStatus.pending,
      ),
      requests: (data['requests'] as List<dynamic>?)
              ?.map((req) => {
                    'type': req['type'] ?? 'UNKNOWN',
                    'details': req['details'] ?? {},
                    'priority': req['priority'] ?? 0,
                  })
              .toList() ??
          [],
    );
  }
}
