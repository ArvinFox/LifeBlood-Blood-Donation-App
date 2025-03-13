import 'package:cloud_firestore/cloud_firestore.dart';

class DonationRequestDetails {
  final int requestId;
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
    required this.contactNumber, 
    required this.city,
    required this.province,
    required this.createdAt
  });

  Map<String, dynamic> toFirestore() {
    return {
      'requestId': requestId,
      'patientName': patientName,
      'contactNumber': contactNumber,
      'requestBloodType': requestBloodType,
      'urgencyLevel': urgencyLevel,
      'hospitalName': hospitalName,
      'city': city,
      'province': province,
      'createdAt': Timestamp.fromDate(createdAt), 
    };
  }

  factory DonationRequestDetails.fromFirestore(Map<String, dynamic> data) {
    return DonationRequestDetails(
      requestId: data['requestId'] ?? '',
      patientName: data['patientName'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      requestBloodType: data['requestBloodType'] ?? '',
      urgencyLevel: data['urgencyLevel'] ?? '',
      hospitalName: data['hospitalName'] ?? '',
      city: data['city'] ?? '',
      province: data['province'] ?? '',
      createdAt: data['createdAt'].toDate(),
    );
  }

}
