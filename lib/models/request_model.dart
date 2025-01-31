import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muieen_project/models/course_model.dart';

import 'advisor_model.dart';
import 'student_model.dart';

enum RequestStatus {
  pending,
  approved,
  rejected,
}

enum RequestType {
  add,
  edit,
  delete,
}

class RequestModel {
  final RequestType type;
  RequestStatus status;
  final CourseModel courseRef;
  final DateTime dateSubmitted;

  RequestModel({
    required this.type,
    this.status = RequestStatus.pending,
    required this.courseRef,
    DateTime? dateSubmitted,
  }) : dateSubmitted = dateSubmitted ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'type': type.toString(),
        'status': status.toString(),
        'courseRef': courseRef.toMap(),
        'dateSubmitted': dateSubmitted.toIso8601String(),
      };

  factory RequestModel.fromMap(Map<String, dynamic> data) {
    return RequestModel(
      type: RequestType.values.firstWhere((e) => e.toString() == data['type']),
      status: RequestStatus.values
          .firstWhere((e) => e.toString() == data['status']),
      courseRef: CourseModel.fromMap(data['courseRef']),
      dateSubmitted: DateTime.parse(data['dateSubmitted']),
    );
  }
}

class AddRequestModel extends RequestModel {
  final String section;
  final String alternativeSection;

  AddRequestModel({
    super.type = RequestType.add,
    super.status,
    required super.courseRef,
    required super.dateSubmitted,
    required this.section,
    required this.alternativeSection,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'section': section,
        'alternativeSection': alternativeSection,
      };

  factory AddRequestModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AddRequestModel(
      type: RequestType.add,
      status: RequestStatus.values.firstWhere(
        (e) => e.toString() == data['status'],
      ),
      courseRef: CourseModel.fromMap(data['courseRef']),
      dateSubmitted: DateTime.parse(data['dateSubmitted']),
      section: data['section'],
      alternativeSection: data['alternativeSection'],
    );
  }
}

class EditRequestModel extends RequestModel {
  final String section;
  final String alternativeSection;

  EditRequestModel({
    super.type = RequestType.edit,
    super.status,
    required super.courseRef,
    required super.dateSubmitted,
    required this.section,
    required this.alternativeSection,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'section': section,
        'alternativeSection': alternativeSection,
      };

  factory EditRequestModel.fromFirestore(Map<String, dynamic> data, String id) {
    return EditRequestModel(
      type: RequestType.edit,
      status: RequestStatus.values.firstWhere(
        (e) => e.toString() == data['status'],
      ),
      courseRef: CourseModel.fromMap(data['courseRef']),
      dateSubmitted: DateTime.parse(data['dateSubmitted']),
      section: data['section'],
      alternativeSection: data['alternativeSection'],
    );
  }
}

class DeleteRequestModel extends RequestModel {
  final String reason;

  DeleteRequestModel({
    super.type = RequestType.delete,
    super.status,
    required super.courseRef,
    required super.dateSubmitted,
    required this.reason,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'reason': reason,
      };

  factory DeleteRequestModel.fromFirestore(
      Map<String, dynamic> data, String id) {
    return DeleteRequestModel(
      type: RequestType.delete,
      status: RequestStatus.values.firstWhere(
        (e) => e.toString() == data['status'],
      ),
      courseRef: CourseModel.fromMap(data['courseRef']),
      dateSubmitted: DateTime.parse(data['dateSubmitted']),
      reason: data['reason'],
    );
  }
}

class RequestGroupModel {
  final String? documentId; // Add this field
  final StudentModel studentRef;
  final AdvisorModel advisorRef;
  final bool isOrdered;
  final List<RequestModel> requests;

  RequestGroupModel({
    required this.documentId,
    required this.studentRef,
    required this.advisorRef,
    required this.isOrdered,
    required this.requests,
  });

  Map<String, dynamic> toMap() => {
        'studentRef': studentRef.toFirestore(),
        'advisorRef': advisorRef.toFirestore(),
        'isOrdered': isOrdered,
        'requests': requests.map((r) => r.toMap()).toList(),
      };

  factory RequestGroupModel.fromFirestore(
      Map<String, dynamic> data, String id) {
    return RequestGroupModel(
      documentId: id,
      studentRef: StudentModel.fromFirestore(
        data['studentRef'],
        data['studentRef'].toString(),
      ),
      advisorRef: AdvisorModel.fromFirestore(
        data['advisorRef'],
        data['advisorRef'].toString(),
      ),
      isOrdered: data['isOrdered'],
      requests: (data['requests'] as List).map((r) {
        final requestType =
            RequestType.values.firstWhere((e) => e.toString() == r['type']);
        switch (requestType) {
          case RequestType.add:
            return AddRequestModel.fromFirestore(r, id);
          case RequestType.edit:
            return EditRequestModel.fromFirestore(r, id);
          case RequestType.delete:
            return DeleteRequestModel.fromFirestore(r, id);
          default:
            throw ArgumentError('Unknown request type: $requestType');
        }
      }).toList(),
    );
  }
}
