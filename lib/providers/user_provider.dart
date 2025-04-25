import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/models/user_model.dart';
import 'package:lifeblood_blood_donation_app/services/user_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';

class UserProvider extends ChangeNotifier{
  final UserService _userService = UserService();
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool  get isLoading => _isLoading;

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
}