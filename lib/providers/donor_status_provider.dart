import 'package:flutter/material.dart';

class DonorStatusProvider extends ChangeNotifier{
  bool _showDonorPoster = true;
  bool _donorDialogShown = false;

  bool get showDonorPoster => _showDonorPoster;
  bool get donorDialogShown => _donorDialogShown;

  void setShowDonorPoster(bool value) {
    _showDonorPoster = value;
    notifyListeners();
  }

  void markDialogShown() {
    _donorDialogShown = true;
    notifyListeners();
  }
}