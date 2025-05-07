import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';
import 'package:lifeblood_blood_donation_app/models/user_model.dart';
import 'package:lifeblood_blood_donation_app/services/request_service.dart';
import 'package:lifeblood_blood_donation_app/services/user_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  final RequestService _requestService = RequestService();

  UserModel? _user;
  String? _currentActivityId;
  BloodRequest? _currentActivity;
  bool _isLoading = false;

  UserModel? get user => _user;
  String? get currentActivityId => _currentActivityId;
  BloodRequest? get currentActivity => _currentActivity;
  bool  get isLoading => _isLoading;

  // Reset user (when logged out)
  void resetUser() {
    _user = null;
    notifyListeners();
  }

  // Fetch user
  Future<void> fetchUser(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      UserModel? userData = await _userService.getUserById(id);
      _user = userData;
      
    } catch (e) {
      Helpers.debugPrintWithBorder("Error fetching user: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  //update user availability status
  Future<void> fetchUserAvailability(String userId, bool isActive) async{
    try {
      await _userService.updateAvailabilityStatus(userId, isActive);
      await fetchUser(userId);
    } catch (e) { 
      Helpers.debugPrintWithBorder("Error creating notification: $e");
      notifyListeners();
    }
  }

  // Update status
  Future<void> updateStatus(String userId, String property, bool value) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userService.updateStatus(userId, property, value);
      await fetchUser(userId);
    } catch (e) {
      Helpers.debugPrintWithBorder("Error updating status: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch current activity/request
  Future<void> fetchCurrentActivity() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _currentActivity = await _requestService.getRequestById(_currentActivityId!);
    } catch (e) {
      Helpers.debugPrintWithBorder("Error fetching current activity: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Load current activity from SharedPreferences
  Future<void> loadCurrentActivity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentActivityId = await prefs.getString("currentActivityId") ?? null;
    fetchCurrentActivity();
  }

  // Save activity to SharedPreferences
  Future<void> saveCurrentActivity(String requestId) async {
    if (_user!.isDonating) return;

    SharedPreferences prefs = await SharedPreferences.getInstance(); 
    _currentActivityId = requestId; 
    await prefs.setString("currentActivityId", _currentActivityId!);
    fetchCurrentActivity();
  }

  // Remove activity from SharedPreferences
  Future<void> removeActivity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("currentActivityId");
    _currentActivityId = null;
    _currentActivity = null;
    notifyListeners();
  }
}