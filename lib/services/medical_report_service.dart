import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood_blood_donation_app/models/medical_report_model.dart';

class MedicalReportService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add medical report
  Future<void> addReport(MedicalReportModel report) async {
    try {
      await _db.collection("medical_reports").doc(report.reportId).set(report.toFirestore());
    } catch (e) {
      throw Exception("Failed to add report: $e");
    }
  }

  // Get medical report by ID
  Future<MedicalReportModel?> getReportById(String reportId) async {
    try {
      DocumentSnapshot reportDoc = await _db.collection("medical_reports").doc(reportId).get();
      if (!reportDoc.exists) return null;

      return MedicalReportModel.fromFirestore(reportDoc);
      
    } catch (e) {
      throw Exception("Failed to get report by id: $e");
    }
  }
}