import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';

class CurrentActivitiesProvider with ChangeNotifier {
  List<BloodRequest> _currentActivities = [];

  List<BloodRequest> get currentActivities => _currentActivities;

  CurrentActivitiesProvider() {
    _loadCurrentActivities();
  }

  // Add activity to current activities and save it to SharedPreferences
  Future<void> addActivity(BloodRequest request) async {
    bool exists = _currentActivities
        .any((activity) => activity.requestId == request.requestId);

    if (!exists) {
      _currentActivities.add(request);
      await _saveCurrentActivities();
      notifyListeners();
    }
  }

  // Load current activities from SharedPreferences
  Future<void> _loadCurrentActivities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? activitiesList = prefs.getStringList('currentActivities');

    if (activitiesList != null) {
      _currentActivities = activitiesList.map((activity) {
        List<String> activityDetails = activity.split(',');
        return BloodRequest(
          requestId: activityDetails[0],
          patientName: activityDetails[1],
          requestBloodType: activityDetails[2],
          urgencyLevel: activityDetails[3],
          hospitalName: activityDetails[4],
          city: activityDetails[5],
          province: activityDetails[6],
          contactNumber: activityDetails[7],
          requestedBy: activityDetails[8],
          requestQuantity: activityDetails[9],
          createdAt: DateTime.parse(activityDetails[10]),
        );
      }).toList();
      notifyListeners();
    }
  }

  // Save current activities to SharedPreferences
  Future<void> _saveCurrentActivities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> activitiesList = _currentActivities.map((activity) {
      return [
        activity.requestId,
        activity.patientName,
        activity.requestBloodType,
        activity.urgencyLevel,
        activity.hospitalName,
        activity.city,
        activity.province,
        activity.contactNumber,
        activity.createdAt.toIso8601String(), // Store the createdAt as a string
      ].join(',');
    }).toList();

    await prefs.setStringList('currentActivities', activitiesList);
  }

  // Optional: Remove an activity
  Future<void> removeActivity(BloodRequest request) async {
    _currentActivities.removeWhere((r) => r.requestId == request.requestId);
    await _saveCurrentActivities();
    notifyListeners();
  }
}
