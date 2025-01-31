import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muieen_project/models/advisor_model.dart';

class AdvisorProvider with ChangeNotifier {
  AdvisorModel? _advisor;

  AdvisorModel? get advisor => _advisor;

  // Fetch advisor information by advisorId
  Future<void> fetchAdvisor(DocumentReference advisorId) async {
    final advisorDoc = await advisorId.get();

    if (advisorDoc.exists) {
      _advisor = AdvisorModel.fromFirestore(
        advisorDoc.data() as Map<String, dynamic>,
        advisorId.id.toString(),
      );
      notifyListeners();
    }
  }
}
