import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/models/donation_history_model.dart';
import 'package:lifeblood_blood_donation_app/services/donation_history_service.dart';

class DonationHistoryProvider extends ChangeNotifier {
  final DonationHistoryService _donationHistoryService = DonationHistoryService();
  List<DonationHistory> _donationHistory = [];
  bool _isLoading = false;

  List<DonationHistory> get donationHistory => _donationHistory;
  bool get isLoading => _isLoading;

  Future<void> fetchDonationHistory(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _donationHistory = await _donationHistoryService.getDonationHistoryOfUser(userId);
    } catch (error) {
      _donationHistory = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}