import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muieen_project/models/advisor_model.dart';
import 'package:muieen_project/models/request_model.dart';
import 'package:muieen_project/models/student_model.dart';
import 'package:muieen_project/models/user_model.dart';
import 'package:muieen_project/providers/auth_provider.dart';

class RequestGroupProvider with ChangeNotifier {
  RequestGroupModel? _currentGroup;

  RequestGroupProvider({
    StudentModel? studentRef,
    AdvisorModel? advisorRef,
  }) {
    if (studentRef != null && advisorRef != null) {
      _currentGroup = RequestGroupModel(
        documentId: null, // Initialize with null or a valid documentId
        studentRef: studentRef,
        advisorRef: advisorRef,
        isOrdered: false,
        requests: [],
      );
    }
  }

  RequestGroupModel? get currentGroup => _currentGroup;
  List<RequestModel> get requests => _currentGroup?.requests ?? [];

  set requests(List<RequestModel> value) {
    if (_currentGroup != null) {
      _currentGroup = RequestGroupModel(
        documentId: _currentGroup!.documentId, // Preserve the documentId
        studentRef: _currentGroup!.studentRef,
        advisorRef: _currentGroup!.advisorRef,
        isOrdered: _currentGroup!.isOrdered,
        requests: value,
      );
      notifyListeners();
    }
  }

  void initializeGroup({
    required StudentModel studentRef,
    required AdvisorModel advisorRef,
  }) {
    _currentGroup = RequestGroupModel(
      documentId: null, // Initialize with null or a valid documentId
      studentRef: studentRef,
      advisorRef: advisorRef,
      isOrdered: false,
      requests: [],
    );
    notifyListeners();
  }

  void _ensureInitialized({
    required StudentModel studentRef,
    required AdvisorModel advisorRef,
  }) {
    if (_currentGroup == null) {
      initializeGroup(studentRef: studentRef, advisorRef: advisorRef);
    }
  }

  void addRequest({
    required RequestModel request,
    required StudentModel studentRef,
    required AdvisorModel advisorRef,
  }) {
    _ensureInitialized(studentRef: studentRef, advisorRef: advisorRef);
    if (_currentGroup != null) {
      _currentGroup!.requests.add(request);
      notifyListeners();
    }
  }

  void removeRequest({
    required int index,
  }) {
    if (_currentGroup != null && index < _currentGroup!.requests.length) {
      _currentGroup!.requests.removeAt(index);
      notifyListeners();
    }
  }

  void updateRequests(List<RequestModel> newRequests) {
    requests = newRequests;
    notifyListeners();
  }

  void setOrdered({
    required bool ordered,
  }) {
    if (_currentGroup != null) {
      _currentGroup = RequestGroupModel(
        documentId: _currentGroup!.documentId, // Preserve the documentId
        studentRef: _currentGroup!.studentRef,
        advisorRef: _currentGroup!.advisorRef,
        isOrdered: ordered,
        requests: _currentGroup!.requests,
      );
      notifyListeners();
    }
  }

  Future<void> submitToDatabase() async {
    if (_currentGroup != null) {
      try {
        // Add a new document to Firestore
        final docRef = await FirebaseFirestore.instance
            .collection('requests')
            .add(_currentGroup!.toMap());

        // Update the documentId in the current group
        _currentGroup = RequestGroupModel(
          documentId: docRef.id, // Set the documentId
          studentRef: _currentGroup!.studentRef,
          advisorRef: _currentGroup!.advisorRef,
          isOrdered: _currentGroup!.isOrdered,
          requests: _currentGroup!.requests,
        );

        clear();

        notifyListeners();
        print("✅ Request group submitted successfully!");
      } catch (e) {
        print("🔥 Error submitting request group: $e");
      }
    }
  }

  Future<void> updateToDatabase(RequestGroupModel group) async {
    try {
      // Ensure the documentId is not null
      if (group.documentId == null) {
        throw ArgumentError(
            'Document ID is required to update a request group.');
      }

      // Update the document in Firestore
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(group.documentId) // Use the documentId
          .update(group.toMap()); // Update with the serialized data

      _currentGroup = group;

      print("✅ Request group updated successfully!");
    } catch (e) {
      print("🔥 Error updating request group: $e");
    }
  }

  void clear() {
    _currentGroup = null;
    requests = [];
    notifyListeners();
  }
}
