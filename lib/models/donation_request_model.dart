import 'package:cloud_firestore/cloud_firestore.dart';

class DonationRequestDetails {
  final String requestId;
  final String patientName;
  final String requestBloodType;
  final String urgencyLevel;
  final String hospitalName;
  final String city;
  final String province;
  final String contactNumber;
  final DateTime createdAt;

  DonationRequestDetails({
    required this.requestId,
    required this.patientName,
    required this.requestBloodType,
    required this.urgencyLevel,
    required this.hospitalName,
    required this.city,
    required this.province,
    required this.contactNumber,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      // 'requestId': requestId,
      'patientName': patientName,
      'requestBloodType': requestBloodType,
      'urgencyLevel': urgencyLevel,
      'hospitalName': hospitalName,
      'city': city,
      'province': province,
      'contactNumber': contactNumber,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Fetch Data from Firestore
  factory DonationRequestDetails.fromFirestore(Map<String, dynamic> data) {
    return DonationRequestDetails(
      requestId: data['requestId'] ?? '',
      patientName: data['patientName'] ?? '',
      requestBloodType: data['requestBloodType'] ?? '',
      urgencyLevel: data['urgencyLevel'] ?? '',
      hospitalName: data['hospitalName'] ?? '',
      city: data['city'] ?? '',
      province: data['province'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
