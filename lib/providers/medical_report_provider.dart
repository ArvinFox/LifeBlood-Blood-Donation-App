import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/models/medical_report_model.dart';
import 'package:lifeblood_blood_donation_app/services/medical_report_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';

class MedicalReportProvider extends ChangeNotifier {
  final MedicalReportService _medicalReportService = MedicalReportService();
  MedicalReportModel? _report;
  bool _isLoading = false;

  MedicalReportModel? get report => _report;
  bool get isLoading => _isLoading;

  // Fetch medical report
  Future<void> fetchReport(String reportId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _report = await _medicalReportService.getReportById(reportId);
    } catch (e) {
      Helpers.debugPrintWithBorder("Error fetching medical report: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}