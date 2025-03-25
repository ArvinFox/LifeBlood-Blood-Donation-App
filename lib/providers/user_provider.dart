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

  Future<void> fetchUser(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      UserModel? userData = await _userService.getUserById(id);
      if(userData != null){
        _user = userData;
      } else{
        _user = null;
      }
      
    } catch (e) {
      Helpers.debugPrintWithBorder("Error fetching user: $e");
    }

    await Future.delayed(Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

}