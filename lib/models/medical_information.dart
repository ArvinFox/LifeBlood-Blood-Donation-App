import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalInfo{
  final String bloodType;
  String? medicalReport;
  final String? healthConditions;
  final DateTime registrationDate;

  MedicalInfo({
    required this.bloodType,
    this.medicalReport,
    this.healthConditions,
    required this.registrationDate,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'bloodType': bloodType,
      'medicalReport': medicalReport, 
      'healthConditions': healthConditions,
      'registrationDate': Timestamp.fromDate(registrationDate), 
    };
  }

  factory MedicalInfo.fromFirestore(Map<String, dynamic> data) {
    return MedicalInfo(
      bloodType: data['bloodType'] ?? '',
      medicalReport:data['medicalReport'] ?? '',
      healthConditions: data['healthConditions'] ?? '',
      registrationDate: data['registrationDate'].toDate(),
    );
  }
}
